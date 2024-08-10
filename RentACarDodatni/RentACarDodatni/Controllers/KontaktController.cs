using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using RentACar.Controllers;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services;
using RentACar.Services.IServices;
using System.Text;
using System.Text.Json;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KontaktController : ControllerBase
    {
        private readonly RentACarDBContext _context;

        private readonly IKontaktService _kontaktService;
        private readonly IKorisniciService _korisniciService;
        private readonly IMapper _mapper;
        private readonly IConfiguration _configuration;

        public KontaktController(IKontaktService kontaktService, IKorisniciService korisniciService, IMapper mapper, IConfiguration configuration, RentACarDBContext context)
        {
            _kontaktService = kontaktService;
            _korisniciService = korisniciService;
            _mapper = mapper;
            _configuration = configuration;
            _context = context;
        }
        [HttpGet]
        public async Task<IActionResult> GetAllContacts()
        {
            var kontakti = await _kontaktService.Get(new KontaktSearchObject());
            if (kontakti == null || kontakti.Count == 0)
            {
                return NotFound("No contacts found.");
            }

            return Ok(kontakti);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetContactsById(int id)
        {
            var kontakti = await _kontaktService.GetById(id);
            if (kontakti == null)
            {
                return NotFound($"Contact with ID {id} not found.");
            }

            return Ok(kontakti);
        }
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] KontaktInsertRequest request)
        {
            if (ModelState.IsValid)
            {
                var kontakt = new RentACar.Services.Database.Kontakt
                {
                    KorisnikId = request.KorisnikId,
                    ImePrezime = request.ImePrezime,
                    Poruka = request.Poruka,
                    Telefon = request.Telefon,
                    Email = request.Email
                };

                _context.Kontakt.Add(kontakt);
                await _context.SaveChangesAsync();

                await SendMessageToRabbitMQ(kontakt.KontaktId, request.Poruka);

                return CreatedAtAction(nameof(GetContactsById), new { id = kontakt.KontaktId }, kontakt);
            }

            return BadRequest(ModelState);
        }

        private async Task SendMessageToRabbitMQ(int kontaktId, string message)
        {
            var factory = new ConnectionFactory
            {
                HostName = _configuration["RABBITMQ_HOST"] ?? "rabbitMQ",
                UserName = _configuration["RABBITMQ_USERNAME"] ?? "guest",
                Password = _configuration["RABBITMQ_PASSWORD"] ?? "guest",
                VirtualHost = _configuration["RABBITMQ_VIRTUALHOST"] ?? "/"
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "kontakt_notifications",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: true,
                                 arguments: null);

            var notification = new { KontaktId = kontaktId, Message = message };
            var json = JsonSerializer.Serialize(notification);
            var body = Encoding.UTF8.GetBytes(json);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "kontakt_notifications",
                                 basicProperties: null,
                                 body: body);

            Console.WriteLine($"[x] Sent {message} for kontakt {kontaktId}");
        }
    }
}

