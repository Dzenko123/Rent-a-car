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

    public class CPVPService:BaseCRUDService<CijenePoVremenskomPeriodu,Database.CijenePoVremenskomPeriodu,CPVPSearchObject,CPVPInsertRequest,CPVPUpdateRequest, CPVPDeleteRequest>,ICPVPService
    {

        public CPVPService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<CijenePoVremenskomPeriodu> Insert(CPVPInsertRequest insert)
        {
            var entity = _mapper.Map<Database.CijenePoVremenskomPeriodu>(insert);
            _context.Set<Database.CijenePoVremenskomPeriodu>().Add(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<CijenePoVremenskomPeriodu>(entity);
        }

        public async Task<CijenePoVremenskomPeriodu> Update(int id, CPVPUpdateRequest update)
        {
            var entity = await _context.Set<Database.CijenePoVremenskomPeriodu>().FindAsync(id);
            if (entity == null)
            {
                throw new ArgumentException("Entity not found");
            }
            var properties = typeof(CPVPUpdateRequest).GetProperties();
            foreach (var property in properties)
            {
                if (property.GetValue(update) != null)
                {
                    var entityProperty = typeof(Database.CijenePoVremenskomPeriodu).GetProperty(property.Name);

                    entityProperty.SetValue(entity, property.GetValue(update));
                }
            }

            
            await _context.SaveChangesAsync();

            return _mapper.Map<CijenePoVremenskomPeriodu>(entity);
        }
    }
}
