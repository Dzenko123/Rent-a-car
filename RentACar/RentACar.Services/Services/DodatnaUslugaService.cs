using AutoMapper;
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
    public class DodatnaUslugaService : BaseCRUDService<Model.Models.DodatnaUsluga, Database.DodatnaUsluga,DodatnaUslugaSearchObject,DodatnaUslugaInsertRequest,DodatnaUslugaUpdateRequest,DodatnaUslugaDeleteRequest>, IDodatnaUslugaService
    {
        public DodatnaUslugaService(RentACarDBContext context, IMapper mapper) : base(context, mapper) 
        { }
    }
}
