using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Lajkovi
    {
        public int LajkId { get; set; }

        public int VoziloId { get; set; }
        public Vozila Vozilo { get; set; } = null!;

        public int KorisnikId { get; set; }
        public Korisnici Korisnik { get; set; }
        public bool Tip { get; set; }
    }
}
