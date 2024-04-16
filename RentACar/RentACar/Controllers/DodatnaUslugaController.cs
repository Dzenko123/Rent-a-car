using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;
using RentACar.Model.Models;
using RentACar.Model.SearchObject;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    public class DodatnaUslugaController : BaseController<DodatnaUsluga, BaseSearchObject>
    {
        public DodatnaUslugaController(ILogger<BaseController<DodatnaUsluga, BaseSearchObject>> logger, 
            IService<DodatnaUsluga, BaseSearchObject> service) : base(logger, service)
        {
        }
    }
}
