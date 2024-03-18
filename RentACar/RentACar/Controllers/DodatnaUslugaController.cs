using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;
using RentACar.Model.SearchObject;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    public class DodatnaUslugaController : BaseController<Model.DodatnaUsluga, BaseSearchObject>
    {
        public DodatnaUslugaController(ILogger<BaseController<Model.DodatnaUsluga, BaseSearchObject>> logger, 
            IService<Model.DodatnaUsluga, BaseSearchObject> service) : base(logger, service)
        {
        }
    }
}
