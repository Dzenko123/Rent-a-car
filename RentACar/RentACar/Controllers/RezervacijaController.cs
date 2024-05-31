using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using RentACar.Services.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RezervacijaController : BaseCRUDController<Rezervacija, Model.SearchObject.RezervacijaSearchObject,Model.Requests.RezervacijaInsertRequest,Model.Requests.RezervacijaUpdateRequest,Model.Requests.RezervacijaDeleteRequest>
    {
        private readonly IRezervacijaService _rezervacijeService;

        public RezervacijaController(ILogger<BaseController<Rezervacija, Model.SearchObject.RezervacijaSearchObject>> logger,
            IRezervacijaService service) : base(logger, service)
        {
            _rezervacijeService = service;
        }

        [HttpGet("KorisnikId/{korisnikId}")]
        public async Task<ActionResult<IEnumerable<Rezervacija>>> GetByKorisnikId(int korisnikId)
        {
            var rezervacije = await _rezervacijeService.GetByKorisnikId(korisnikId);
            return Ok(rezervacije);
        }
        [HttpPost("InsertWithDodatneUsluge")]
        public async Task<ActionResult<Rezervacija>> InsertRezervacijaWithDodatneUsluge(RezervacijaInsertRequest request)
        {
            try
            {
                var rezervacija = await _rezervacijeService.InsertRezervacijaWithDodatneUsluge(request);
                return Ok(rezervacija);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

    }
}
