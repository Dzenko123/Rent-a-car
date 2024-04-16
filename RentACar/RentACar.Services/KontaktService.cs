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
    public class KontaktService : BaseCRUDService<Kontakt, Database.Kontakt, KontaktSearchObject, KontaktInsertRequest, KontaktUpdateRequest, KontaktDeleteRequest>, IKontaktService
    {
        public KontaktService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<Kontakt> Insert(KontaktInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Kontakt>(insert);
            _context.Set<Database.Kontakt>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Kontakt>(entity);
        }
    }
}
