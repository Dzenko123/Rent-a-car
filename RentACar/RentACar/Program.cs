using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using RentACar;
using RentACar.Filters;
using RentACar.Model.Models;
using RentACar.Model.SearchObject;
using RentACar.Services;
using RentACar.Services.IServices;
using RentACar.Services.Services;
using RentACar.Services.VozilaStateMachine;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using RentACar.Model.Requests;
using System.Text;
using System.Text.Json;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IDodatnaUslugaService, DodatnaUslugaService>();
builder.Services.AddTransient<ITipVozilaService, TipVozilaService>();
builder.Services.AddTransient<IGorivoService, GorivoService>();
builder.Services.AddTransient<IGradService, GradService>();
builder.Services.AddTransient<IVozilaService, VozilaService>();
builder.Services.AddTransient<IVoziloPregledService, VoziloPregledService>();
builder.Services.AddTransient<IKontaktService, KontaktService>();
builder.Services.AddTransient<ICPVPService, CPVPService>();
builder.Services.AddTransient<IPeriodService, PeriodService>();
builder.Services.AddTransient<IRecenzijeService, RecenzijeService>();
builder.Services.AddTransient<IKomentariService, KomentariService>();


builder.Services.AddTransient<IRezervacijaService, RezervacijaService>();
builder.Services.AddTransient<IRezervacijaDodatnaUslugaService, RezervacijaDodatnaUslugaService>();
builder.Services.AddTransient<IService<DodatnaUsluga, BaseSearchObject>,
    BaseService<DodatnaUsluga, RentACar.Services.Database.DodatnaUsluga, BaseSearchObject>>();



builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<InitialVozilaState>();
builder.Services.AddTransient<DraftVozilaState>();
builder.Services.AddTransient<ActiveVozilaState>();



builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference= new OpenApiReference{Type= ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}

    }
    });
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<RentACarDBContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<RentACarDBContext>();
    dataContext.Database.Migrate();
}

string hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ";
string username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
string password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
string virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";

var factory = new ConnectionFactory
{
    HostName = hostname,
    UserName = username,
    Password = password,
    VirtualHost = virtualHost,
};

using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "kontakt_added",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);

Console.WriteLine(" [*] Waiting for messages.");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += async (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Console.WriteLine(message);

    var insertRequest = JsonSerializer.Deserialize<KontaktInsertRequest>(message);
    using (var scope = app.Services.CreateScope())
    {
        var kontaktService = scope.ServiceProvider.GetRequiredService<IKontaktService>();

        if (insertRequest != null)
        {
            try
            {
                var result = await kontaktService.Insert(insertRequest);
                if (result != null)
                {
                    Console.WriteLine("Kontakt uspješno dodat.");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error handling contact addition: {e.Message}");
            }
        }
    }
};

channel.BasicConsume(queue: "kontakt_added", autoAck: true, consumer: consumer);

app.Run();
