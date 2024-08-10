using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Kontakt
    {
        public int KontaktId { get; set; }

        public int KorisnikId { get; set; }

        public Korisnici Korisnik { get; set; } = null!;
        public string ImePrezime { get; set; }
        public string Poruka { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string Email { get; set; } = null!;
    }
}
