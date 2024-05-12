using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Services
{
    public class KomentariService : BaseCRUDService<Model.Models.Komentari, Database.Komentari, KomentariSearchObject, KomentariInsertRequest, KomentariUpdateRequest, KomentariDeleteRequest>, IKomentariService
    {
        private readonly RentACarDBContext _context;

        public KomentariService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public async Task<IEnumerable<Komentari>> GetKomentariForVozilo(int voziloId)
        {
            var komentariFromDb = await _context.Komentari
                                                .Where(k => k.VoziloId == voziloId)
                                                .ToListAsync();

            var komentari = _mapper.Map<IEnumerable<Model.Models.Komentari>>(komentariFromDb);

            return komentari;
        }

    }

}
