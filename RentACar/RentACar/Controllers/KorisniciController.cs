using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class KorisniciController : BaseCRUDController<Model.Korisnici, Model.SearchObject.KorisniciSearchObject, Model.Requests.KorisniciInsertRequest, Model.Requests.KorisniciUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Korisnici, Model.SearchObject.KorisniciSearchObject>> logger,
                IKorisniciService service) : base(logger, service)
        {
        }
    }
}
