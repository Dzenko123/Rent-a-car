using AutoMapper;
using EasyNetQ.Internals;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace RentACar.Services.Services
{
    public class RezervacijaService : BaseCRUDService<Rezervacija, Database.Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest, RezervacijaDeleteRequest>, IRezervacijaService
    {
        private readonly RentACarDBContext _context;
        private readonly IMapper _mapper;

        public RezervacijaService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<IEnumerable<Rezervacija>> GetByKorisnikId(int korisnikId)
        {
            var rezervacijeFromDb = await _context.Rezervacija
                                                    .Include(r => r.DodatnaUsluga)
                                                        .ThenInclude(ru => ru.DodatnaUsluga)
                                                    .Where(r => r.KorisnikId == korisnikId)
                                                    .ToListAsync();

            var rezervacije = _mapper.Map<IEnumerable<Model.Models.Rezervacija>>(rezervacijeFromDb);

            return rezervacije;
        }
        public override IQueryable<Database.Rezervacija> AddInclude(IQueryable<Database.Rezervacija> query, RezervacijaSearchObject? search = null)
        {
            if (search?.IsDodatneUslugeIncluded == true)
            {
                query = query.Include("DodatnaUsluga");
            }
            return base.AddInclude(query, search);
        }
        public async Task<Rezervacija> InsertRezervacijaWithDodatneUsluge(RezervacijaInsertRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var set = _context.Set<Database.Rezervacija>();

                var dbRezervacija = _mapper.Map<Database.Rezervacija>(request);
                dbRezervacija.Zahtjev = false;
                set.Add(dbRezervacija);

                await _context.Rezervacija.AddAsync(dbRezervacija);
                await _context.SaveChangesAsync();

                if (request.DodatnaUslugaId != null)
                {
                    foreach (var uslugaId in request.DodatnaUslugaId)
                    {
                        var dbRezervacijaDodatnaUsluga = new Database.RezervacijaDodatnaUsluga
                        {
                            RezervacijaId = dbRezervacija.RezervacijaId,
                            DodatnaUslugaId = uslugaId
                        };
                        await _context.RezervacijaDodatnaUsluga.AddAsync(dbRezervacijaDodatnaUsluga);
                    }
                    await _context.SaveChangesAsync();
                }

                await transaction.CommitAsync();
                return _mapper.Map<Rezervacija>(dbRezervacija);
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                throw new Exception("An error occurred while creating the reservation with additional services", ex);
            }
        }
        public async Task<bool> Otkazivanje(int rezervacijaId)
        {
            var rezervacija = await _context.Rezervacija.FindAsync(rezervacijaId);
            if (rezervacija == null)
                return false;

            rezervacija.Zahtjev = true;
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> Potvrda(int rezervacijaId)
        {
            var rezervacija = await _context.Rezervacija.FindAsync(rezervacijaId);
            if (rezervacija == null || rezervacija.Zahtjev != true)
                return false;

            _context.Rezervacija.Remove(rezervacija);
            await _context.SaveChangesAsync();

            return true;
        }
        public async Task<bool> GradIsInUse(int gradId)
        {
            return await _context.Rezervacija.AnyAsync(r => r.GradId == gradId);
        }

        public async Task<bool> DodatnaUslugaIsInUse(int dodatnaUslugaId)
        {
            return await _context.RezervacijaDodatnaUsluga.AnyAsync(rd => rd.DodatnaUslugaId == dodatnaUslugaId);
        }


        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Models.Rezervacija> Recommend(int voziloId)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();
                    var tmpData = _context.Rezervacija.Include(r => r.Vozilo).ToList();

                    var data = new List<RezervacijaEntry>();

                    foreach (var x in tmpData)
                    {
                        var distinctVoziloId = x.VoziloId;
                        var relatedRezervacije = _context.Rezervacija
                            .Where(r => r.KorisnikId != x.KorisnikId && r.VoziloId != distinctVoziloId)
                            .ToList()
                            .GroupBy(r => r.VoziloId)
                            .Where(g => g.Count() >= 2)
                            .SelectMany(g => g)
                            .ToList();

                        foreach (var related in relatedRezervacije)
                        {
                            data.Add(new RezervacijaEntry()
                            {
                                RezervacijaID = (uint)x.RezervacijaId,
                                CoPurchaseRezervacijaID = (uint)related.VoziloId,
                            });
                        }
                    }

                    var traindata = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(RezervacijaEntry.RezervacijaID);
                    options.MatrixRowIndexColumnName = nameof(RezervacijaEntry.CoPurchaseRezervacijaID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(traindata);
                }
            }

            var korisnikIds = _context.Rezervacija
                .Where(r => r.VoziloId == voziloId)
                .Select(r => r.KorisnikId)
                .Distinct()
                .ToList();

            var predictionResult = new List<Tuple<Database.Rezervacija, float>>();

            var relatedVozila = _context.Rezervacija
                 .Where(r => korisnikIds.Contains(r.KorisnikId) && r.VoziloId != voziloId)
                 .ToList()
                 .GroupBy(r => r.VoziloId)
                 .Where(g => g.Count() >= 2)
                 .Select(g => g.Key)
                 .ToList();

            foreach (var relatedVoziloId in relatedVozila)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<RezervacijaEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(
                    new RezervacijaEntry()
                    {
                        RezervacijaID = (uint)voziloId,
                        CoPurchaseRezervacijaID = (uint)relatedVoziloId
                    });

                var relatedVozilo = _context.Rezervacija.FirstOrDefault(r => r.VoziloId == relatedVoziloId);

                predictionResult.Add(new Tuple<Database.Rezervacija, float>(relatedVozilo, prediction.Score));
            }

            var finalResult = predictionResult
                .OrderByDescending(x => x.Item2)
                .Select(x => x.Item1)
                .Take(3)
                .ToList();

            return _mapper.Map<List<Model.Models.Rezervacija>>(finalResult);
        }
    }
    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class RezervacijaEntry
    {
        [KeyType(count: 10)]
        public uint RezervacijaID { get; set; }

        [KeyType(count: 10)]
        public uint CoPurchaseRezervacijaID { get; set; }

        public float Label { get; set; }
    }
}
