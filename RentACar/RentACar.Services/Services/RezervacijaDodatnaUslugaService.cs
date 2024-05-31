using AutoMapper;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using RentACar.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Services
{
    public class RezervacijaDodatnaUslugaService : BaseCRUDService<Model.Models.RezervacijaDodatnaUsluga, Database.RezervacijaDodatnaUsluga, RezervacijaDodatnaUslugaSearchObject, RezervacijaDodatnaUslugaInsertRequest, RezervacijaDodatnaUslugaUpdateRequest, RezervacijaDodatnaUslugaDeleteRequest>, IRezervacijaDodatnaUslugaService
    {
        public RezervacijaDodatnaUslugaService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        { }
    }
}
