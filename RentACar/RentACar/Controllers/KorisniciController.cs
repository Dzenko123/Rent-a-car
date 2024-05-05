using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model.Models;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class KorisniciController : BaseCRUDController<Korisnici, Model.SearchObject.KorisniciSearchObject, Model.Requests.KorisniciInsertRequest, Model.Requests.KorisniciUpdateRequest, Model.Requests.KorisniciDeleteRequest>
    {
        private readonly IKorisniciService _korisniciService;

        public KorisniciController(ILogger<BaseController<Korisnici, Model.SearchObject.KorisniciSearchObject>> logger,
                IKorisniciService service, IKorisniciService korisniciService) : base(logger, service)
        {
            _korisniciService = korisniciService;
        }

        [HttpGet("GetLoged")]
        public virtual async Task<IActionResult> GetLoged(string username, string password)
        {
            var korisnikId = await _korisniciService.GetLoged(username, password);
            if (korisnikId != null)
            {
                return Ok(korisnikId);
            }
            else
            {
                return NotFound("Korisnik nije pronađen ili pogrešna lozinka.");
            }
        }
    }
}
