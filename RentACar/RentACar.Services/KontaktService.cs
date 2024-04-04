using AutoMapper;
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
    public class KontaktService : BaseCRUDService<Model.Kontakt, Database.Kontakt, KontaktSearchObject, KontaktInsertRequest, KontaktUpdateRequest>, IKontaktService
    {
        public BaseState _baseState { get; set; }
        public KontaktService(BaseState baseState, RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public async Task<Model.Kontakt> Insert(KontaktInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Kontakt>(insert);
            _context.Set<Database.Kontakt>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Kontakt>(entity);
        }
    }
}
