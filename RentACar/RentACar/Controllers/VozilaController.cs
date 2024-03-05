using Microsoft.AspNetCore.Mvc;
using RentACar.Model;
using RentACar.Services;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VozilaController : ControllerBase
    {
        private readonly IVozilaService _vozilaService;
        private readonly ILogger<WeatherForecastController> _logger;

        public VozilaController(ILogger<WeatherForecastController> logger, IVozilaService vozilaService)
        {
            _logger = logger;
            _vozilaService = vozilaService;
        }

        [HttpGet()]
        public IEnumerable<Vozila> Get()
        {
            return _vozilaService.Get();
        }
    }
}