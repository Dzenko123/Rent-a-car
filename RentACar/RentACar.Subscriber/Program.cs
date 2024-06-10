using Microsoft.Extensions.Configuration;
using EasyNetQ;
using RentACar.Model.Models;

var builder = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();

IConfiguration configuration = builder.Build();
var rabbitMqHost = configuration["RabbitMQ:Host"] ?? "localhost";

using var bus = RabbitHutch.CreateBus($"host={rabbitMqHost}");
bus.PubSub.Subscribe<Vozila>("test", HandleTextMessage);
Console.WriteLine("Listening for messages. Hit <return> to quit");
Console.ReadLine();

void HandleTextMessage(Vozila entity)
{
    Console.WriteLine($"Received: {entity?.VoziloId}, {entity?.Marka}");
}
