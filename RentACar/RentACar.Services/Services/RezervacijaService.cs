using AutoMapper;
using Microsoft.EntityFrameworkCore;
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

        public async Task<Rezervacija> InsertRezervacijaWithDodatneUsluge(RezervacijaInsertRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var dbRezervacija = _mapper.Map<Database.Rezervacija>(request);
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
    }
}
