using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Services
{
    public class KontaktService : IKontaktService
    {
        private readonly RentACarDBContext _context;
        private readonly IMapper _mapper;

        public KontaktService(RentACarDBContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<Kontakt>> Get(KontaktSearchObject searchObject)
        {
            var query = _context.Kontakt.AsQueryable();

            var kontakt = await query.ToListAsync();
            return _mapper.Map<List<Kontakt>>(kontakt);
        }

        public async Task<Kontakt> GetById(int id)
        {
            var kontakt = await _context.Kontakt.FindAsync(id);
            return _mapper.Map<Kontakt>(kontakt);
        }
        public async Task<Kontakt> Post(KontaktInsertRequest request)
        {
            var kontakt = new RentACar.Services.Database.Kontakt
            {
                KorisnikId = request.KorisnikId,
                ImePrezime = request.ImePrezime,
                Poruka = request.Poruka,
                Telefon = request.Telefon,
                Email = request.Email
            };

            _context.Kontakt.Add(kontakt);
            await _context.SaveChangesAsync();

            return _mapper.Map<Kontakt>(kontakt);
        }
    }
}
