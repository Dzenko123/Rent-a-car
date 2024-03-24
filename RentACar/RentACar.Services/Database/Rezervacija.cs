using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Rezervacija
    {
        public int RezervacijaId { get; set; }

        public int KorisnikId { get; set; }

        public Korisnici Korisnik { get; set; } = null!;

        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;


        public int RacunId { get; set; }

        public Racun Racun { get; set; } = null!;

        public int LokacijaId { get; set; }

        public Lokacija Lokacija { get; set; } = null!;

        public int KalendarRezervacijaId { get; set; }
        public KalendarRezervacija KalendarRezervacija { get; set; }

        public DateTime PocetniDatum { get; set; }

        public DateTime ZavrsniDatum { get; set; }

        public virtual ICollection<RezervacijaDodatnaUsluga> DodatneUsluge { get; } = new List<RezervacijaDodatnaUsluga>();
    }
}
