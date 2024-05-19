using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;
using RentACar.Model.Models;
using RentACar.Model.SearchObject;
using RentACar.Services;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class DodatnaUslugaController : BaseCRUDController<DodatnaUsluga, Model.SearchObject.DodatnaUslugaSearchObject, Model.Requests.DodatnaUslugaInsertRequest, Model.Requests.DodatnaUslugaUpdateRequest, Model.Requests.DodatnaUslugaDeleteRequest>
    {
        public DodatnaUslugaController(ILogger<BaseController<DodatnaUsluga, Model.SearchObject.DodatnaUslugaSearchObject>> logger,
            IDodatnaUslugaService service) : base(logger, service)
        {
        }
    }
}
