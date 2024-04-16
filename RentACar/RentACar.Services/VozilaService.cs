using AutoMapper;
using RentACar.Model;
using RentACar.Model.Models;
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
    public class VozilaService : BaseCRUDService<Vozila, Database.Vozila, VozilaSearchObject, VozilaInsertRequest, VozilaUpdateRequest,VozilaDeleteRequest>, IVozilaService
    {
        public BaseState _baseState { get; set; }

        public VozilaService(BaseState baseState,RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }
        public override IQueryable<Database.Vozila> AddFilter(IQueryable<Database.Vozila> query, VozilaSearchObject? search = null)
        {
            var filteredQuery =  base.AddFilter(query, search);
            if(!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Model.Contains(search.FTS));
            }

            return filteredQuery;
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

        public override async Task<Vozila> Delete(int id, VozilaDeleteRequest delete)
        {
            var entity = await _context.Vozila.FindAsync(id);

            if (entity == null)
            {
                throw new Exception($"Vozilo s ID-em {id} nije pronađeno.");
            }

            var state = _baseState.CreateState(entity.StateMachine);

            if (state is DraftVozilaState draftState)
            {
                // Ako je stanje DraftVozilaState, pozovi metodu Delete s requestom.
                return await draftState.Delete(id, delete);
            }
            else
            {
                // Ako nije stanje DraftVozilaState, baci izuzetak.
                throw new UserException("Not allowed");
            }
        }


        public async Task<Vozila> Activate(int id)
        {
            var entity = await _context.Vozila.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Vozila> Hide(int id)
        {
            var entity = await _context.Vozila.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Vozila.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }
    }
}
