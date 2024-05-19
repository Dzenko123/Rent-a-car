using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using RentACar.Services.VozilaStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Services
{
    public class RezervacijaService : BaseCRUDService<Rezervacija, Database.Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest, RezervacijaDeleteRequest>, IRezervacijaService
    {
        private readonly RentACarDBContext _context;

        public RezervacijaService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;

        }
        public async Task<IEnumerable<Rezervacija>> GetByKorisnikId(int korisnikId)
        {
            var rezervacijeFromDb = await _context.Rezervacija
                                                .Where(r => r.KorisnikId == korisnikId)
                                                .ToListAsync();

            var rezervacije = _mapper.Map<IEnumerable<Model.Models.Rezervacija>>(rezervacijeFromDb);

            return rezervacije;
        }

    }
}
