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
    public class GradService: BaseCRUDService<Model.Models.Grad, Database.Grad,GradSearchObject, GradInsertRequest, GradUpdateRequest, GradDeleteRequest>, IGradService
    {
        public GradService (RentACarDBContext context, IMapper mapper):base(context,mapper)
        { }
    }
}
