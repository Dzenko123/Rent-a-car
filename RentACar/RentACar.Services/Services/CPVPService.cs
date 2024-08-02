using AutoMapper;
using Microsoft.EntityFrameworkCore;
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

namespace RentACar.Services.Services
{

    public class CPVPService : BaseCRUDService<CijenePoVremenskomPeriodu, Database.CijenePoVremenskomPeriodu, CPVPSearchObject, CPVPInsertRequest, CPVPUpdateRequest, CPVPDeleteRequest>, ICPVPService
    {

        public CPVPService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.CijenePoVremenskomPeriodu> AddFilter(IQueryable<Database.CijenePoVremenskomPeriodu> query, CPVPSearchObject search = null)
        {
            if (search != null && search.VoziloId > 0)
            {
                query = query.Where(c => c.VoziloId == search.VoziloId);
            }

            return base.AddFilter(query, search);
        }
        public override IQueryable<Database.CijenePoVremenskomPeriodu> AddInclude(IQueryable<Database.CijenePoVremenskomPeriodu> query, CPVPSearchObject search = null)
        {
                query = query.Include(c => c.Period);
           

            return base.AddInclude(query, search);
        }

        public async Task<bool> DeleteByVoziloId(int voziloId)
        {
            var items = await _context.CijenePoVremenskomPeriodu
                .Where(c => c.VoziloId == voziloId)
                .ToListAsync();

            if (items == null || items.Count < 0)
            {
                return false;
            }

            _context.CijenePoVremenskomPeriodu.RemoveRange(items);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
