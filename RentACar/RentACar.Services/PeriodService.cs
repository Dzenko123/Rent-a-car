using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.VozilaStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public class PeriodService:BaseCRUDService<Period,Database.Period,PeriodSearchObject,PeriodInsertRequest,PeriodUpdateRequest,PeriodDeleteRequest>, IPeriodService
    {
        public BaseState _baseState { get; set; }
        public PeriodService(BaseState baseState,RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }
        public async Task<Period> Insert(PeriodInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Period>(insert);
            _context.Set<Database.Period>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Period>(entity);
        }
        public override async Task<Period> Delete(int id, PeriodDeleteRequest delete)
        {
            var period = await _context.Set<Database.Period>().FindAsync(id);

            if (period == null)
            {
                return null;
            }

            var cijenePoVremenskomPeriodu = await _context.Set<Database.CijenePoVremenskomPeriodu>()
                .Where(c => c.PeriodId == id)
                .ToListAsync();

            foreach (var cpvp in cijenePoVremenskomPeriodu)
            {
                _context.Set<Database.CijenePoVremenskomPeriodu>().Remove(cpvp);
            }

            _context.Set<Database.Period>().Remove(period);

            await _context.SaveChangesAsync();

            return _mapper.Map<Period>(period);
        }
    }
}
