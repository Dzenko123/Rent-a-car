using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model;
using RentACar.Model.SearchObject;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KontaktController : BaseCRUDController<Model.Kontakt, Model.SearchObject.KontaktSearchObject, Model.Requests.KontaktInsertRequest, Model.Requests.KontaktUpdateRequest>
    {
        public KontaktController(ILogger<BaseController<Model.Kontakt, Model.SearchObject.KontaktSearchObject>> logger, 
            IKontaktService service) : base(logger, service)
        {
        }
    }
}

