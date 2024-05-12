using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KontaktController : BaseCRUDController<Kontakt, Model.SearchObject.KontaktSearchObject, Model.Requests.KontaktInsertRequest, Model.Requests.KontaktUpdateRequest,Model.Requests.KontaktDeleteRequest>
    {
        public KontaktController(ILogger<BaseController<Kontakt, KontaktSearchObject>> logger, IKontaktService service) : base(logger, service)
        {
        }
    }
}

