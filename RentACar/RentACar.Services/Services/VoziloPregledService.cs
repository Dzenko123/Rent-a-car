using AutoMapper;
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
    public class VoziloPregledService : BaseCRUDService<Model.Models.VoziloPregled, Database.VoziloPregled, VoziloPregledSearchObject, VoziloPregledInsertRequest, VoziloPregledUpdateRequest, VoziloPregledDeleteRequest>, IVoziloPregledService
    {
        public VoziloPregledService(RentACarDBContext context, IMapper mapper)
        : base(context, mapper)
        {
        }
    }
}
