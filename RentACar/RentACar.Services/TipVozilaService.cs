using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.Database;
using RentACar.Services.VozilaStateMachine;

namespace RentACar.Services
{

    public class TipVozilaService : BaseCRUDService<Model.TipVozila, Database.TipVozila, TipVozilaSearchObject, TipVozilaInsertRequest, TipVozilaUpdateRequest>, ITipVozilaService
    {
        public BaseState _baseState { get; set; }

        public TipVozilaService(BaseState baseState, RentACarDBContext context, IMapper mapper)
            : base(context, mapper)
        {
            _baseState = baseState;
        }



        //public override IQueryable<Database.TipVozila> AddFilter(IQueryable<Database.TipVozila> query, TipVozilaSearchObject? search = null)
        //{
        //    if (!string.IsNullOrWhiteSpace(search?.Marka))
        //    {
        //        query = query.Where(x => x.Marka.StartsWith(search.Marka));
        //    }
        //    if (!string.IsNullOrWhiteSpace(search?.FTS))
        //    {
        //        query = query.Where(x => x.Marka.Contains(search.FTS));
        //    }
        //    return base.AddFilter(query, search);
        //}


        public async Task<Model.TipVozila> Insert(TipVozilaInsertRequest insert)
        {
            var entity = _mapper.Map<Database.TipVozila>(insert);
            _context.Set<Database.TipVozila>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.TipVozila>(entity);
        }

        public async Task<Model.TipVozila> Update(int id, TipVozilaUpdateRequest update)
        {
            var entity = await _context.Set<Database.TipVozila>().FindAsync(id);
            if (entity == null)
            {
                throw new ArgumentException("Entity not found");
            }

            _mapper.Map(update, entity);

            _context.Entry(entity).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.TipVozila>(entity);
        }

    }
}
