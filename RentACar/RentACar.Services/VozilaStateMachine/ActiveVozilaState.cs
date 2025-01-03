﻿using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;

namespace RentACar.Services.VozilaStateMachine
{
    public class ActiveVozilaState : BaseState
    {
        public ActiveVozilaState(IServiceProvider serviceProvider, RentACarDBContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }
        public override async Task<Vozila> Hide(int id)
        {
            var set = _context.Set<Database.Vozila>();
            var entity = await set.FindAsync(id);

            entity.StateMachine = "draft";
            await _context.SaveChangesAsync();
            return _mapper.Map<Vozila>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Hide");
            return list;
        }

        public override async Task<List<Vozila>> GetActiveVehicles()
        {
            var set = _context.Set<Database.Vozila>();
            var activeVehicles = await set.Where(v => v.StateMachine == "active").ToListAsync();
            return _mapper.Map<List<Vozila>>(activeVehicles);
        }
    }
}
