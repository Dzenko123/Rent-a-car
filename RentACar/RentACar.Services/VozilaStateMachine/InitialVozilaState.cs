﻿using AutoMapper;
using RentACar.Model.Models;
using RentACar.Model.Requests;

namespace RentACar.Services.VozilaStateMachine
{
    public class InitialVozilaState:BaseState
    {
        public InitialVozilaState(IServiceProvider serviceProvider, RentACarDBContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }

        public override async Task<Vozila> Insert(VozilaInsertRequest request)
        {
            var set = _context.Set<Database.Vozila>();
            var entity = _mapper.Map<Database.Vozila>(request);

            entity.StateMachine = "draft";
            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Vozila>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Insert");
            return list;
        }
    }
}
