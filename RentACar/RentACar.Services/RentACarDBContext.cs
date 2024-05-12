using Microsoft.EntityFrameworkCore;
using RentACar.Services.Database;

namespace RentACar.Services
{
    public partial class RentACarDBContext : DbContext
    { 

        public DbSet<Korisnici> Korisnicis { get; set; }
        public DbSet<CijenePoVremenskomPeriodu> CijenePoVremenskomPeriodu { get; set; }
        public DbSet<DodatnaUsluga> DodatnaUsluga { get; set; }
        public DbSet<Grad> Grad { get; set; }
        public DbSet<Kontakt> Kontakt { get; set; }
        public DbSet<KorisniciUloge> KorisniciUloge { get; set; }
        public DbSet<Recenzije> Recenzije { get; set;}
        public DbSet<Komentari> Komentari { get; set;}
        public DbSet<Rezervacija> Rezervacija { get; set; }
        public DbSet<RezervacijaDodatnaUsluga> RezervacijaDodatnaUsluga { get; set; }
        public DbSet<TipVozila> TipVozila { get; set; }
        public DbSet<Uloge> Uloge { get; set; }
        public DbSet<Vozila> Vozila { get; set; }
        public DbSet<Period> Period { get; set; }
        public DbSet<VoziloPregled> VoziloPregled { get; set; }

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
