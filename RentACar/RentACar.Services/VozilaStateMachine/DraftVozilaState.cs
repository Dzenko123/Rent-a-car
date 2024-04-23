using AutoMapper;
using EasyNetQ;
using Microsoft.Extensions.Logging;
using RabbitMQ.Client;
using RentACar.Model;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace RentACar.Services.VozilaStateMachine
{
    public class DraftVozilaState : BaseState
    {
        protected ILogger _logger;
        public DraftVozilaState(ILogger<DraftVozilaState> logger,IServiceProvider serviceProvider, RentACarDBContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
            _logger = logger;
        }

        public override async Task<Vozila> Update(int id, VozilaUpdateRequest request)
        {
            var set = _context.Set<Database.Vozila>();
            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);
            if (entity.Cijena < 0)
            {
                throw new Exception("Cijena ne smije biti u minusu!");
            }
            if(entity.Cijena<1)
            {
                throw new UserException("Cijena ispod minimuma!");
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<Vozila>(entity);
        }
        public async Task<Vozila> Delete(int id, VozilaDeleteRequest request)
        {
            try
            {
                var set = _context.Set<Database.Vozila>();
                var entity = await set.FindAsync(id);

                if (entity == null)
                {
                    throw new Exception($"Vozilo s ID-em {id} nije pronađeno.");
                }
                set.Remove(entity);
                await _context.SaveChangesAsync();

                return _mapper.Map<Vozila>(entity);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Greška prilikom brisanja vozila.");
                throw;
            }
        }


        public override async Task<Vozila> Activate(int id)
        {
            _logger.LogInformation($"Aktivacija vozila:{id}");
            _logger.LogWarning($"W: Aktivacija vozila:{id}");
            _logger.LogError($"E: Aktivacija vozila:{id}");

            var set = _context.Set<Database.Vozila>();
            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";
            await _context.SaveChangesAsync();


            //var factory = new ConnectionFactory { HostName = "localhost" };
            //using var connection = factory.CreateConnection();
            //using var channel = connection.CreateModel();

            //const string message = "Hello World";
            //var body = Encoding.UTF8.GetBytes(message);
            //channel.BasicPublish(exchange: string.Empty,
            //                     routingKey: "vozilo_added",
            //                     basicProperties: null,
            //                     body: body);



            var mappedEntity = _mapper.Map<Vozila>(entity);

            using var bus = RabbitHutch.CreateBus("host=localhost");
            bus.PubSub.Publish(mappedEntity);

            return mappedEntity;
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Update");
            list.Add("Delete");
            list.Add("Activate");
            return list;
        }
    }
}
