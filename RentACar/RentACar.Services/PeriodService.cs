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
    public class PeriodService:BaseCRUDService<Model.Period,Database.Period,PeriodSearchObject,PeriodInsertRequest,PeriodUpdateRequest>, IPeriodService
    {
        public BaseState _baseState { get; set; }
        public PeriodService(BaseState baseState,RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }
        public async Task<Model.Period> Insert(PeriodInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Period>(insert);
            _context.Set<Database.Period>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Period>(entity);
        }
    }
}
