//using RabbitMQ.Client.Events;
//using RabbitMQ.Client;
//using System.Text;
//using EasyNetQ;
//using RentACar.Model.Models;

//Console.WriteLine("Hello, World!");

//using (var bus = RabbitHutch.CreateBus("host=rabbitmq"))
//{
//    bus.PubSub.Subscribe<Vozila>("test", HandleTextMessage);
//    Console.WriteLine("Listening for messages. Hit <return> to quit");
//    Console.ReadLine();
//}

//void HandleTextMessage(Vozila entity)
//{
//    Console.WriteLine($"Recieved: {entity?.VoziloId}, {entity?.Marka}");
//}