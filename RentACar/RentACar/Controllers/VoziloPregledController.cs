using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VoziloPregledController : BaseCRUDController<VoziloPregled, Model.SearchObject.VoziloPregledSearchObject,Model.Requests.VoziloPregledInsertRequest,Model.Requests.VoziloPregledUpdateRequest,Model.Requests.VoziloPregledDeleteRequest>
    {
        public VoziloPregledController(ILogger<BaseController<VoziloPregled, Model.SearchObject.VoziloPregledSearchObject>> logger,
            IVoziloPregledService service) : base (logger,service)
        {
        }
    }
}
