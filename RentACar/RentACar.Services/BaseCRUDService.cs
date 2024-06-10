using AutoMapper;
using RentACar.Model.SearchObject;

namespace RentACar.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate, TDelete> : BaseService<T, TDb, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb entity, TInsert insert)
        {

        }
        public virtual async Task BeforeUpdate(TDb entity, TUpdate update)
        {

        }
        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();
            TDb entity=_mapper.Map<TDb>(insert);
            set.Add(entity);

            await BeforeInsert(entity, insert);
            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Update(int id, TUpdate update)
            {
            var set = _context.Set<TDb>();
            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity); await BeforeUpdate(entity, update);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }


        public virtual async Task<T> Delete(int id, TDelete delete)
        {
            try
            {
                var set = _context.Set<TDb>();
                var entity = await set.FindAsync(id);

                if (entity == null)
                {
                    return null;
                }
                set.Remove(entity);

                await _context.SaveChangesAsync();
                return _mapper.Map<T>(entity);
            }
            catch (Exception ex)
            {
            
                Console.WriteLine($"Greška prilikom brisanja entiteta: {ex.Message}");
                throw;
            }
        }
        public virtual async Task UpdatePasswordAndUsername(int id, TUpdate update)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            if (entity == null)
            {
                throw new Exception($"{typeof(T).Name} with id {id} not found");
            }

            _mapper.Map(update, entity);

            _context.Update(entity);
            await _context.SaveChangesAsync();
        }

    }
}
