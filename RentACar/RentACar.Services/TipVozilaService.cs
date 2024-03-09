using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.SearchObject;
using RentACar.Services.Database;

namespace RentACar.Services
{
    public class TipVozilaService : BaseService<Model.TipVozila, Database.TipVozila, TipVozilaSearchObject>, ITipVozilaService
    {
        public TipVozilaService(RentACarDBContext context, IMapper mapper)
            :base(context,mapper)
        {
        }



        public override IQueryable<Database.TipVozila> AddFilter(IQueryable<Database.TipVozila> query, TipVozilaSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Marka))
            {
                query = query.Where(x => x.Marka.StartsWith(search.Marka));
            }
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Marka.Contains(search.FTS));
            }
            return base.AddFilter(query, search);
        }
    }
}
