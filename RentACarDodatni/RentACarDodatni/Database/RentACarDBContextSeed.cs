using Microsoft.EntityFrameworkCore;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public partial class RentACarDBContext
    {
        private readonly DateTime _dateTime = DateTime.Now.AddDays(+4);
        private readonly DateTime _dateTime2 = DateTime.Now.AddDays(+6);

       private void SeedData(ModelBuilder modelBuilder)
        {
            SeedKorisnici(modelBuilder);
            SeedUloge(modelBuilder);
            SeedKorisniciUloge(modelBuilder);
            SeedKontakt(modelBuilder);
        }

        private void SeedKorisnici(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Korisnici>().HasData(
                new Korisnici
                {
                    KorisnikId = 1,
                    Ime = "admin",
                    Prezime = "admin",
                    Email = "adminadmin@gmail.com",
                    Telefon = "060000000",
                    KorisnickoIme = "admin",
                    LozinkaHash = "JfJzsL3ngGWki+Dn67C+8WLy73I=",
                    LozinkaSalt = "7TUJfmgkkDvcY3PB/M4fhg==",
                },
                new Korisnici
                {
                    KorisnikId = 2,
                    Ime = "user1",
                    Prezime = "user1",
                    Email = "user1@gmail.com",
                    Telefon = "060000001",
                    KorisnickoIme = "test1",
                    LozinkaHash = "PEPuXC0FRTDz8Ep3LtkrCzwN0Kw=", //Plain text: test
                    LozinkaSalt = "1wQEjdSFeZttx6dlvEDjOg==",
                },
                new Korisnici
                {
                    KorisnikId = 3,
                    Ime = "user2",
                    Prezime = "user2",
                    Email = "user2@gmail.com",
                    Telefon = "060000002",
                    KorisnickoIme = "test2",
                    LozinkaHash = "PEPuXC0FRTDz8Ep3LtkrCzwN0Kw=", //Plain text: test
                    LozinkaSalt = "1wQEjdSFeZttx6dlvEDjOg==",
                });
        }

        private void SeedUloge(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Uloge>().HasData(
                new Uloge
                {
                    UlogaId = 1,
                    Naziv = "admin",
                    Opis = "admin"
                },
                new Uloge
                {
                    UlogaId = 2,
                    Naziv = "user",
                    Opis = "user"
                });
        }
        private void SeedKorisniciUloge(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<KorisniciUloge>().HasData(
                new KorisniciUloge
                {
                    KorisnikUlogaId = 1,
                    KorisnikId = 1,
                    UlogaId = 1,
                    DatumIzmjene = DateTime.Now
                },
                new KorisniciUloge
                {
                    KorisnikUlogaId = 2,
                    KorisnikId = 2,
                    UlogaId = 2,
                    DatumIzmjene = DateTime.Now
                },
                new KorisniciUloge
                {
                    KorisnikUlogaId = 3,
                    KorisnikId = 3,
                    UlogaId = 2,
                    DatumIzmjene = DateTime.Now
                }
                );
        }
        private void SeedKontakt(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Kontakt>().HasData(
                new Kontakt
                {
                    KontaktId = 1,
                    KorisnikId = 2,
                    ImePrezime = "Test Test1",
                    Poruka = "test1",
                    Telefon = "060000000",
                    Email = "test1@mail.com"
                },
                 new Kontakt
                 {
                     KontaktId = 2,
                     KorisnikId = 2,
                     ImePrezime = "Test Test2",
                     Poruka = "test2",
                     Telefon = "060000001",
                     Email = "test2@mail.com"
                 },
                  new Kontakt
                  {
                      KontaktId = 3,
                      KorisnikId = 3,
                      ImePrezime = "Test Test3",
                      Poruka = "test3",
                      Telefon = "060000002",
                      Email = "test3@mail.com"
                  },
                   new Kontakt
                   {
                       KontaktId = 4,
                       KorisnikId = 3,
                       ImePrezime = "Test Test4",
                       Poruka = "test4",
                       Telefon = "060000003",
                       Email = "test4@mail.com"
                   });
        }

    }
}
