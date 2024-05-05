using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RecenzijeController : BaseCRUDController<Recenzije, Model.SearchObject.RecenzijeSearchObject, Model.Requests.RecenzijeInsertRequest, Model.Requests.RecenzijeUpdateRequest, Model.Requests.RecenzijeDeleteRequest>
    {
        public RecenzijeController(ILogger<BaseController<Recenzije, Model.SearchObject.RecenzijeSearchObject>> logger, IRecenzijeService service) : base(logger, service)
        {
        }
    }
}
