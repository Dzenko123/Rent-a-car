using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CPVPController : BaseCRUDController<CijenePoVremenskomPeriodu, Model.SearchObject.CPVPSearchObject, Model.Requests.CPVPInsertRequest, Model.Requests.CPVPUpdateRequest,Model.Requests.CPVPDeleteRequest>
    {
        public CPVPController(ILogger<BaseController<CijenePoVremenskomPeriodu, CPVPSearchObject>> logger, 
            ICPVPService service) : base(logger, service)
        {
        }
    }
}
