using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

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
        [HttpGet("GetByVoziloId/{voziloId}")]
        public async Task<ActionResult<IEnumerable<CijenePoVremenskomPeriodu>>> GetByVoziloId(int voziloId)
        {
            if (voziloId <= 0)
            {
                return BadRequest("VoziloId je obavezno polje.");
            }

            var searchObject = new CPVPSearchObject { VoziloId = voziloId, IsPeriodIncluded = true };
            var result = await _service.Get(searchObject);

            if (result == null || result.Count == 0)
            {
                return NotFound("Nema pronađenih rezultata za dati VoziloId.");
            }

            return Ok(result.Result);
        }

        [HttpDelete("DeleteByVoziloId/{voziloId}")]
        public async Task<IActionResult> DeleteByVoziloId(int voziloId)
        {
            if (voziloId <= 0)
            {
                return BadRequest("VoziloId je obavezno polje.");
            }

            var success = await (_service as ICPVPService).DeleteByVoziloId(voziloId);

            if (!success)
            {
                return NotFound("Nema pronađenih cijena za dati VoziloId.");
            }

            return Ok(new { message = "Sve cijene za navedeni VoziloId su uspješno obrisane." });
        }

    }
}
