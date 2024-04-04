using Microsoft.AspNetCore.Mvc;
using RentACar.Model;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PeriodController : BaseCRUDController<Model.Period, Model.SearchObject.PeriodSearchObject, Model.Requests.PeriodInsertRequest, Model.Requests.PeriodUpdateRequest>
    {
        public PeriodController(ILogger<BaseController<Period, PeriodSearchObject>> logger, IPeriodService service) : base(logger, service)
        {
        }
    }
}
