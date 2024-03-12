using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VozilaController : BaseCRUDController<Vozila, Model.SearchObject.VozilaSearchObject, Model.Requests.VozilaInsertRequest, Model.Requests.VozilaUpdateRequest>
    {
        public VozilaController(ILogger<BaseController<Vozila, Model.SearchObject.VozilaSearchObject>> logger,
                IVozilaService service) : base(logger, service)
        {
        }
        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Vozila> Activate(int id)
        {
            return await (_service as IVozilaService).Activate(id);
        }
    }
}
