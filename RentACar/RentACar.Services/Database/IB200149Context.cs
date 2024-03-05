using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace RentACar.Services.Database
{
    public partial class IB200149Context : DbContext
    {
        public IB200149Context()
        {
        }

        public IB200149Context(DbContextOptions<IB200149Context> options)
            : base(options)
        {
        }

        public virtual DbSet<DodatnaUsluga> DodatnaUslugas { get; set; } = null!;
        public virtual DbSet<Izlazi> Izlazis { get; set; } = null!;
        public virtual DbSet<Kontakt> Kontakts { get; set; } = null!;
        public virtual DbSet<Korisnici> Korisnicis { get; set; } = null!;
        public virtual DbSet<KorisniciUloge> KorisniciUloges { get; set; } = null!;
        public virtual DbSet<Kupci> Kupcis { get; set; } = null!;
        public virtual DbSet<Lokacija> Lokacijas { get; set; } = null!;
        public virtual DbSet<Narudzba> Narudzbas { get; set; } = null!;
        public virtual DbSet<Ocjene> Ocjenes { get; set; } = null!;
        public virtual DbSet<TipVozila> TipVozilas { get; set; } = null!;
        public virtual DbSet<Ulazi> Ulazis { get; set; } = null!;
        public virtual DbSet<Vozilo> Vozilos { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Data Source=localhost;Initial Catalog=IB200149;User Id=dzenan;Password=dzenandzenan123;TrustServerCertificate=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<DodatnaUsluga>(entity =>
            {
                entity.ToTable("DodatnaUsluga");

                entity.Property(e => e.DodatnaUslugaId).ValueGeneratedNever();

                entity.Property(e => e.Naziv)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Opis).IsUnicode(false);
            });

            modelBuilder.Entity<Izlazi>(entity =>
            {
                entity.HasKey(e => e.IzlazId)
                    .HasName("PK__Izlazi__15389920C9766705");

                entity.ToTable("Izlazi");

                entity.Property(e => e.IzlazId).ValueGeneratedNever();

                entity.Property(e => e.BrojRacuna)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.Property(e => e.IznosBezPdv).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.IznosSaPdv).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Izlazis)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Izlazi__Korisnik__4E88ABD4");

                entity.HasOne(d => d.Narudba)
                    .WithMany(p => p.Izlazis)
                    .HasForeignKey(d => d.NarudbaId)
                    .HasConstraintName("FK__Izlazi__NarudbaI__4F7CD00D");
            });

            modelBuilder.Entity<Kontakt>(entity =>
            {
                entity.ToTable("Kontakt");

                entity.Property(e => e.KontaktId).ValueGeneratedNever();

                entity.Property(e => e.Adresa)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Email)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Telefon)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Kontakts)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Kontakt__Korisni__52593CB8");
            });

            modelBuilder.Entity<Korisnici>(entity =>
            {
                entity.HasKey(e => e.KorisnikId)
                    .HasName("PK__Korisnic__80B06D41F277EEAC");

                entity.ToTable("Korisnici");

                entity.HasIndex(e => e.KorisnickoIme, "UQ__Korisnic__992E6F92078D1F80")
                    .IsUnique();

                entity.Property(e => e.KorisnikId).ValueGeneratedNever();

                entity.Property(e => e.Email)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Ime)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.KorisnickoIme)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.LozinkaHash)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.LozinkaSalt)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Prezime)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Telefon)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<KorisniciUloge>(entity =>
            {
                entity.HasKey(e => e.KorisnikUlogaId)
                    .HasName("PK__Korisnic__1608726EB01E5961");

                entity.ToTable("KorisniciUloge");

                entity.Property(e => e.KorisnikUlogaId).ValueGeneratedNever();

                entity.Property(e => e.DatumIzmjene).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.KorisniciUloges)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Korisnici__Koris__276EDEB3");
            });

            modelBuilder.Entity<Kupci>(entity =>
            {
                entity.HasKey(e => e.KupacId)
                    .HasName("PK__Kupci__A9593F9B6AB1E141");

                entity.ToTable("Kupci");

                entity.HasIndex(e => e.KorisnickoIme, "UQ__Kupci__992E6F9218CACF11")
                    .IsUnique();

                entity.Property(e => e.KupacId).ValueGeneratedNever();

                entity.Property(e => e.DatumRegistracije).HasColumnType("datetime");

                entity.Property(e => e.Email)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Ime)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.KorisnickoIme)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.LozinkaHash)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.LozinkaSalt)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Prezime)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Lokacija>(entity =>
            {
                entity.ToTable("Lokacija");

                entity.Property(e => e.LokacijaId).ValueGeneratedNever();

                entity.Property(e => e.Adresa)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Grad)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Narudzba>(entity =>
            {
                entity.ToTable("Narudzba");

                entity.Property(e => e.NarudzbaId).ValueGeneratedNever();

                entity.Property(e => e.BrojNarudzbe).HasMaxLength(255);

                entity.Property(e => e.PocetniDatum).HasColumnType("datetime");

                entity.Property(e => e.ZavrsniDatum).HasColumnType("datetime");

                entity.HasOne(d => d.Grad)
                    .WithMany(p => p.Narudzbas)
                    .HasForeignKey(d => d.GradId)
                    .HasConstraintName("FK__Narudzba__GradId__47DBAE45");

                entity.HasOne(d => d.Kupac)
                    .WithMany(p => p.Narudzbas)
                    .HasForeignKey(d => d.KupacId)
                    .HasConstraintName("FK__Narudzba__Korisn__45F365D3");

                entity.HasOne(d => d.Vozilo)
                    .WithMany(p => p.Narudzbas)
                    .HasForeignKey(d => d.VoziloId)
                    .HasConstraintName("FK__Narudzba__Vozilo__46E78A0C");

                entity.HasMany(d => d.DodatnaUslugas)
                    .WithMany(p => p.Narudzbas)
                    .UsingEntity<Dictionary<string, object>>(
                        "NarudzbaDodatneUsluge",
                        l => l.HasOne<DodatnaUsluga>().WithMany().HasForeignKey("DodatnaUslugaId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__NarudzbaD__Dodat__4BAC3F29"),
                        r => r.HasOne<Narudzba>().WithMany().HasForeignKey("NarudzbaId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__NarudzbaD__Narud__4AB81AF0"),
                        j =>
                        {
                            j.HasKey("NarudzbaId", "DodatnaUslugaId").HasName("PK__Narudzba__F21D5BB9F1C7E29E");

                            j.ToTable("NarudzbaDodatneUsluge");
                        });

                entity.HasMany(d => d.Izlazs)
                    .WithMany(p => p.Narudzbas)
                    .UsingEntity<Dictionary<string, object>>(
                        "NarudzbaIzlazi",
                        l => l.HasOne<Izlazi>().WithMany().HasForeignKey("IzlazId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__NarudzbaI__Izlaz__5629CD9C"),
                        r => r.HasOne<Narudzba>().WithMany().HasForeignKey("NarudzbaId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__NarudzbaI__Narud__5535A963"),
                        j =>
                        {
                            j.HasKey("NarudzbaId", "IzlazId").HasName("PK__Narudzba__EABF9AE54AAAD0E5");

                            j.ToTable("NarudzbaIzlazi");
                        });
            });

            modelBuilder.Entity<Ocjene>(entity =>
            {
                entity.HasKey(e => e.OcjenaId)
                    .HasName("PK__Ocjene__E6FC7AA92FD390A8");

                entity.ToTable("Ocjene");

                entity.Property(e => e.OcjenaId).ValueGeneratedNever();

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Ocjenes)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Ocjene__Korisnik__3B75D760");

                entity.HasOne(d => d.KorisnikNavigation)
                    .WithMany(p => p.Ocjenes)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK_Ocjene_Kupac");

                entity.HasOne(d => d.Vozilo)
                    .WithMany(p => p.Ocjenes)
                    .HasForeignKey(d => d.VoziloId)
                    .HasConstraintName("FK__Ocjene__VoziloId__3C69FB99");
            });

            modelBuilder.Entity<TipVozila>(entity =>
            {
                entity.ToTable("TipVozila");

                entity.Property(e => e.TipVozilaId).ValueGeneratedNever();

                entity.Property(e => e.Naziv)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Ulazi>(entity =>
            {
                entity.HasKey(e => e.UlazId)
                    .HasName("PK__Ulazi__732B788D4FF38658");

                entity.ToTable("Ulazi");

                entity.Property(e => e.UlazId).ValueGeneratedNever();

                entity.Property(e => e.BrojFakture)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.Property(e => e.IznosRacuna).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Napomena)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Pdv).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Ulazis)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Ulazi__KorisnikI__2D27B809");
            });

            modelBuilder.Entity<Vozilo>(entity =>
            {
                entity.ToTable("Vozilo");

                entity.Property(e => e.VoziloId).ValueGeneratedNever();

                entity.Property(e => e.GodinaProizvodnje)
                    .HasMaxLength(4)
                    .IsUnicode(false);

                entity.Property(e => e.Marka)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Model)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Naziv)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Registrovan)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.HasOne(d => d.TipVozila)
                    .WithMany(p => p.Vozilos)
                    .HasForeignKey(d => d.TipVozilaId)
                    .HasConstraintName("FK__Vozilo__TipVozil__38996AB5");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
