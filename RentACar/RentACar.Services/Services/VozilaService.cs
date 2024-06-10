using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model;
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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace RentACar.Services.Services
{
    public class VozilaService : BaseCRUDService<Vozila, Database.Vozila, VozilaSearchObject, VozilaInsertRequest, VozilaUpdateRequest, VozilaDeleteRequest>, IVozilaService
    {
        public BaseState _baseState { get; set; }

        public VozilaService(BaseState baseState, RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }
        public override IQueryable<Database.Vozila> AddFilter(IQueryable<Database.Vozila> query, VozilaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (!string.IsNullOrWhiteSpace(search?.FTS))
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
                return await draftState.Delete(id, delete);
            }
            else
            {
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

        public async Task<PagedResult<Vozila>> GetActiveVehicles(VozilaSearchObject search)
        {
            var state = _baseState.CreateState("active") as ActiveVozilaState;
            if (state == null)
            {
                throw new UserException("Invalid state for retrieving active vehicles");
            }

            var activeVehiclesQuery = _context.Vozila.AsQueryable();

            activeVehiclesQuery = activeVehiclesQuery.Where(v => v.StateMachine == "active");

            activeVehiclesQuery = AddFilter(activeVehiclesQuery, search);
            activeVehiclesQuery = AddInclude(activeVehiclesQuery, search);

            var count = await activeVehiclesQuery.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                activeVehiclesQuery = activeVehiclesQuery.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var vehiclesList = await activeVehiclesQuery.ToListAsync();

            var vehicles = _mapper.Map<List<Vozila>>(vehiclesList);

            return new PagedResult<Vozila>
            {
                Result = vehicles,
                Count = count
            };
        }


        public async Task<Vozila> GetActiveVehicleById(int id)
        {

            var entity = await _context.Vozila.FindAsync(id);

            if (entity == null)
            {
                return null;
            }

            if (entity.StateMachine != "active")
            {
                return null;
            }

            return _mapper.Map<Vozila>(entity);
        }

    }
}
