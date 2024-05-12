using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PeriodController : BaseCRUDController<Period, Model.SearchObject.PeriodSearchObject, Model.Requests.PeriodInsertRequest, Model.Requests.PeriodUpdateRequest,Model.Requests.PeriodDeleteRequest>
    {
        public PeriodController(ILogger<BaseController<Period, PeriodSearchObject>> logger, IPeriodService service) : base(logger, service)
        {
        }
    }
}
