using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Services.Database;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class KorisniciController : ControllerBase
    {
        private readonly IKorisniciService _service;
        private readonly ILogger<WeatherForecastController> _logger;

        public KorisniciController(ILogger<WeatherForecastController> logger, IKorisniciService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet]
        public async Task<IEnumerable<Model.Korisnici>> Get()
        {
            return await _service.Get();
        }

        [HttpPost]
        public Model.Korisnici Insert(KorisniciInsertRequest request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public Model.Korisnici Update(int id, KorisniciUpdateRequest request)
        { 
            return _service.Update(id, request);
        }
    }
}
