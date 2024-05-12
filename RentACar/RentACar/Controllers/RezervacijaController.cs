using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RezervacijaController : BaseCRUDController<Rezervacija, Model.SearchObject.RezervacijaSearchObject,Model.Requests.RezervacijaInsertRequest,Model.Requests.RezervacijaUpdateRequest,Model.Requests.RezervacijaDeleteRequest>
    {
        public RezervacijaController(ILogger<BaseController<Rezervacija, Model.SearchObject.RezervacijaSearchObject>> logger,
            IRezervacijaService service) : base(logger, service)
        {
        }
    }
}
