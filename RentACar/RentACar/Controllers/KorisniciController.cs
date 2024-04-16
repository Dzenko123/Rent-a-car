using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model.Models;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class KorisniciController : BaseCRUDController<Korisnici, Model.SearchObject.KorisniciSearchObject, Model.Requests.KorisniciInsertRequest, Model.Requests.KorisniciUpdateRequest,Model.Requests.KorisniciDeleteRequest>
    {
        public KorisniciController(ILogger<BaseController<Korisnici, Model.SearchObject.KorisniciSearchObject>> logger,
                IKorisniciService service) : base(logger, service)
        {
        }
    }
}
