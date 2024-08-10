using AutoMapper;
using RabbitMQ.Client;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using System.Text;
using System.Text.Json;

namespace RentACar.Services.Services
{
    public class KontaktService : BaseCRUDService<Kontakt, Database.Kontakt, KontaktSearchObject, KontaktInsertRequest, KontaktUpdateRequest, KontaktDeleteRequest>, IKontaktService
    {
        private readonly ConnectionFactory _factory;
        private readonly string _queueName = "kontakt_added";

        public KontaktService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
            _factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ",
                UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
                Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
                VirtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/"
            };
        }

        public override async Task<Kontakt> Insert(KontaktInsertRequest insert)
        {
            var kontakt = await base.Insert(insert);

            SendMessageToQueue(insert);

            return kontakt;
        }

        private void SendMessageToQueue(KontaktInsertRequest insertRequest)
        {
            using var connection = _factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: _queueName, durable: false, exclusive: false, autoDelete: false, arguments: null);

            var message = JsonSerializer.Serialize(insertRequest);
            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: "", routingKey: _queueName, basicProperties: null, body: body);
            Console.WriteLine(" [x] Sent {0}", message);
        }
    }
}
