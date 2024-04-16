using AutoMapper;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.VozilaStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public class RezervacijaService : BaseCRUDService<Rezervacija, Database.Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest,RezervacijaDeleteRequest>, IRezervacijaService
    {
        public RezervacijaService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<Rezervacija> Insert(RezervacijaInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Rezervacija>(insert);
            _context.Set<Database.Rezervacija>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Rezervacija>(entity);
        }
    }
}
