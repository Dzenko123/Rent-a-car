using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KomentariController : BaseCRUDController<Komentari, Model.SearchObject.KomentariSearchObject, Model.Requests.KomentariInsertRequest, Model.Requests.KomentariUpdateRequest, Model.Requests.KomentariDeleteRequest>
    {
        private readonly IKomentariService _komentariService;

        public KomentariController(ILogger<BaseController<Komentari, KomentariSearchObject>> logger, IKomentariService komentariService) : base(logger, komentariService)
        {
            _komentariService = komentariService;
        }

        [HttpGet("VoziloId/{voziloId}")]
        public async Task<ActionResult<IEnumerable<Komentari>>> GetKomentariForVozilo(int voziloId)
        {
            var komentari = await _komentariService.GetKomentariForVozilo(voziloId);
            return Ok(komentari);
        }
    }

}
