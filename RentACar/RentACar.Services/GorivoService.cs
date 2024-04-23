using AutoMapper;
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
    public class GorivoService : BaseCRUDService<Model.Models.Gorivo, Database.Gorivo, GorivoSearchObject, GorivoInsertRequest, GorivoUpdateRequest, GorivoDeleteRequest>, IGorivoService
    {

        public GorivoService(RentACarDBContext context, IMapper mapper)
            : base(context, mapper)
        {
        }
    }
}
