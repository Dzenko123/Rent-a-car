using AutoMapper;
using RentACar.Model;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.VozilaStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace RentACar.Services
{
    public class VozilaService : BaseCRUDService<Vozila, Database.Vozila, VozilaSearchObject, VozilaInsertRequest, VozilaUpdateRequest>, IVozilaService
    {
        public BaseState _baseState { get; set; }

        public VozilaService(BaseState baseState,RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public override Task<Vozila> Insert(VozilaInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);
        }

        public override async Task<Vozila> Update(int id, VozilaUpdateRequest update)
        {
            var entity = await _context.Vozila.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }

        public async Task<Model.Vozila> Activate(int id)
        {
            var entity = await _context.Vozila.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }
    }
}
