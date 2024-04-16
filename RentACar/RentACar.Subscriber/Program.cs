// See https://aka.ms/new-console-template for more information
using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System.Text;
using EasyNetQ;
using RentACar.Model.Models;

Console.WriteLine("Hello, World!");


//var factory = new ConnectionFactory { HostName = "localhost" };
//using var connection = factory.CreateConnection();
//using var channel = connection.CreateModel();

//channel.QueueDeclare(queue: "vozilo_added",
//                     durable: false,
//                     exclusive: false,
//                     autoDelete: false,
//                     arguments: null);

//Console.WriteLine(" [*] Waiting for messages.");

//var consumer = new EventingBasicConsumer(channel);
//consumer.Received += (model, ea) =>
//{
//    var body = ea.Body.ToArray();
//    var message = Encoding.UTF8.GetString(body);
//    Console.WriteLine($" [x] Received {message}");
//};
//channel.BasicConsume(queue: "vozilo_added",
//                     autoAck: true,
//                     consumer: consumer);

//Console.WriteLine(" Press [enter] to exit.");
//Console.ReadLine();

using ( var bus = RabbitHutch.CreateBus("host=localhost"))
{
    bus.PubSub.Subscribe<Vozila>("test", HandleTextMessage);
    Console.WriteLine("Listening for messages. Hit <return> to quit");
    Console.ReadLine();
}

void HandleTextMessage(Vozila entity)
{
    Console.WriteLine($"Recieved: {entity?.VoziloId}, {entity?.Cijena}");
}