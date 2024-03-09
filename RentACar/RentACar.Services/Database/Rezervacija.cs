using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Rezervacija")]
    public class Rezervacija
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Korisnici")]
        public int KorisnikId { get; set; }

        public Korisnici Korisnik { get; set; } = null!;

        [ForeignKey("Vozila")]
        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;

        [ForeignKey("Lokacija")]
        public int LokacijaId { get; set; }

        public Lokacija Lokacija { get; set; } = null!;

        public DateTime PocetniDatum { get; set; }

        public DateTime ZavrsniDatum { get; set; }

        public List<Racun> Racuni { get; set; } = new List<Racun>();
        public List<RezervacijaDodatnaUsluga> DodatneUsluge { get; set; } = new List<RezervacijaDodatnaUsluga>();
    }
}
