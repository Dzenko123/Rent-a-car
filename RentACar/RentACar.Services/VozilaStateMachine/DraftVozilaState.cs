using AutoMapper;
using RentACar.Model;
using RentACar.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace RentACar.Services.VozilaStateMachine
{
    public class DraftVozilaState : BaseState
    {
        public DraftVozilaState(IServiceProvider serviceProvider, RentACarDBContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Vozila> Update(int id, VozilaUpdateRequest request)
        {
            var set = _context.Set<Database.Vozila>();
            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Vozila>(entity);
        }

        public override async Task<Vozila> Activate(int id)
        {
            var set = _context.Set<Database.Vozila>();
            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Vozila>(entity);
        }
    }
}
