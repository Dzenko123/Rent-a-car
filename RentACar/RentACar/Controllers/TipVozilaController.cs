using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model.Models;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TipVozilaController : BaseCRUDController<TipVozila, Model.SearchObject.TipVozilaSearchObject, Model.Requests.TipVozilaInsertRequest, Model.Requests.TipVozilaUpdateRequest,Model.Requests.TipVozilaDeleteRequest>
    {
        public TipVozilaController(ILogger<BaseController<TipVozila, Model.SearchObject.TipVozilaSearchObject>> logger, 
            ITipVozilaService service) : base(logger, service)
        {
        }
    }
}
