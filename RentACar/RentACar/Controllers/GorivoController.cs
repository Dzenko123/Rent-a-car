using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class GorivoController : BaseCRUDController<Gorivo, Model.SearchObject.GorivoSearchObject, Model.Requests.GorivoInsertRequest, Model.Requests.GorivoUpdateRequest, Model.Requests.GorivoDeleteRequest>
    {
        public GorivoController(ILogger<BaseController<Gorivo, Model.SearchObject.GorivoSearchObject>> logger, IGorivoService service) : base(logger, service)
        {
        }
    }
}