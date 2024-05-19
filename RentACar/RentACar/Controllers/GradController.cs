using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class GradController : BaseCRUDController<Grad, Model.SearchObject.GradSearchObject, Model.Requests.GradInsertRequest,Model.Requests.GradUpdateRequest,Model.Requests.GradDeleteRequest>
    {
        public GradController(ILogger<BaseController<Grad, Model.SearchObject.GradSearchObject>>logger, IGradService service): base(logger, service)
        {
        }
    }
}
