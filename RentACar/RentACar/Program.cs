using Microsoft.EntityFrameworkCore;
using RentACar.Model.SearchObject;
using RentACar.Services;
//using RentACar.Services.Database;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<ITipVozilaService, TipVozilaService>();
builder.Services.AddTransient<IService<RentACar.Model.DodatnaUsluga, BaseSearchObject>, 
    BaseService<RentACar.Model.DodatnaUsluga, RentACar.Services.Database.DodatnaUsluga, BaseSearchObject>>();
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<RentACarDBContext>(options => 
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
