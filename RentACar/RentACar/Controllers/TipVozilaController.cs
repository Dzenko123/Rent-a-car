using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model;

namespace RentACar.Controllers
{
    [ApiController]

    public class TipVozilaController : BaseController<Model.TipVozila, Model.SearchObject.TipVozilaSearchObject>
    {
        public TipVozilaController(ILogger<BaseController<TipVozila, Model.SearchObject.TipVozilaSearchObject>> logger, 
            ITipVozilaService service) : base(logger, service)
        {
        }
    }
}
