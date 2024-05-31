using Microsoft.AspNetCore.Mvc;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RezervacijaDodatnaUslugaController : BaseCRUDController<RezervacijaDodatnaUsluga, Model.SearchObject.RezervacijaDodatnaUslugaSearchObject, Model.Requests.RezervacijaDodatnaUslugaInsertRequest, Model.Requests.RezervacijaDodatnaUslugaUpdateRequest, Model.Requests.RezervacijaDodatnaUslugaDeleteRequest>
    {
        public RezervacijaDodatnaUslugaController(ILogger<BaseController<RezervacijaDodatnaUsluga, Model.SearchObject.RezervacijaDodatnaUslugaSearchObject>> logger, IRezervacijaDodatnaUslugaService service) : base(logger, service)
        {
        }
    }
}
