using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Services.IServices;

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
        [HttpPut("UpdatePasswordAndUsername")]
        public virtual async Task<IActionResult> UpdatePasswordAndUsername(int id, string oldPassword, KorisniciUpdateRequestLimited request)
        {
            try
            {
                var isOldPasswordCorrect = await _korisniciService.VerifyOldPassword(id, oldPassword);

                if (!isOldPasswordCorrect)
                {
                    return BadRequest("Stari password nije ispravan.");
                }

                await _korisniciService.UpdatePasswordAndUsername(id, request);
                return Ok("Uspješno ažuriran korisničko ime i/ili lozinka.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Greška prilikom ažuriranja: {ex.Message}");
            }
        }

        [HttpPost]
        [AllowAnonymous]
        public override async Task<Korisnici> Insert([FromBody] KorisniciInsertRequest insert)
        {
            return await _service.Insert(insert);
        }

    }
}
