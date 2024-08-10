using Microsoft.EntityFrameworkCore;
using RentACar.Services.Database;

namespace RentACar.Services
{
    public partial class RentACarDBContext : DbContext
    { 

        public DbSet<Korisnici> Korisnicis { get; set; }
 
        public DbSet<KorisniciUloge> KorisniciUloge { get; set; }

        public DbSet<Kontakt> Kontakt { get; set; }
        public DbSet<Uloge> Uloge { get; set; }

        public RentACarDBContext(DbContextOptions<RentACarDBContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            SeedData(modelBuilder);

            ApplyConfigurations(modelBuilder);
        }
    }
}
