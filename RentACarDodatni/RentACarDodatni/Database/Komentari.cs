using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Komentari
    {
        public int KomentarId { get; set; }
        public int KorisnikId { get; set; }
        public Korisnici Korisnik { get; set; } = null!;

        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;
        public string Komentar { get; set; }

    }
}
