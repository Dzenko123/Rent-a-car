using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TipVozilaController : BaseCRUDController<Model.TipVozila, Model.SearchObject.TipVozilaSearchObject, Model.Requests.TipVozilaInsertRequest, Model.Requests.TipVozilaUpdateRequest>
    {
        public TipVozilaController(ILogger<BaseController<TipVozila, Model.SearchObject.TipVozilaSearchObject>> logger, 
            ITipVozilaService service) : base(logger, service)
        {
        }
    }
}
