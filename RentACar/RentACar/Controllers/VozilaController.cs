using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Model.Models;
using RentACar.Services.IServices;
using RentACar.Model.SearchObject;
using RentACar.Model;
using RentACar.Services.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VozilaController : BaseCRUDController<Vozila, Model.SearchObject.VozilaSearchObject, Model.Requests.VozilaInsertRequest, Model.Requests.VozilaUpdateRequest,Model.Requests.VozilaDeleteRequest>
    {
        private readonly IVozilaService _vozilaService;


        public VozilaController(ILogger<BaseController<Vozila, Model.SearchObject.VozilaSearchObject>> logger,
                IVozilaService service) : base(logger, service)
        {
            _vozilaService = service;

        }
        [HttpPut("{id}/activate")]
        public virtual async Task<Vozila> Activate(int id)
        {
            return await (_service as IVozilaService).Activate(id);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<Vozila> Hide(int id)
        {
            return await (_service as IVozilaService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IVozilaService).AllowedActions(id);

        }

        [HttpGet("active")]
        public async Task<ActionResult<PagedResult<Vozila>>> GetActiveVehicles([FromQuery] VozilaSearchObject search)
        {
            var vozila = await _vozilaService.GetActiveVehicles(search);
            if (vozila == null)
            {
                return NotFound();
            }
            return Ok(vozila);
        }

        [HttpGet("{id}/active")]
        public async Task<ActionResult<Vozila>> GetActiveVehicleById(int id)
        {
            var vozilo = await (_service as IVozilaService).GetActiveVehicleById(id);

            if (vozilo == null)
            {
                return NotFound();
            }

            return vozilo;
        }

    }
}
