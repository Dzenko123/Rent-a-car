using AutoMapper;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public class RecenzijeService : BaseCRUDService<Model.Models.Recenzije, Database.Recenzije, RecenzijeSearchObject, RecenzijeInsertRequest, RecenzijeUpdateRequest, RecenzijeDeleteRequest>, IRecenzijeService
    {
        public RecenzijeService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
