using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Recenzije
    {
        public int RecenzijaId { get; set; }

        public int KorisnikId { get; set; }
        public Korisnici Korisnik { get; set; } = null!;

        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;

        public bool IsLiked { get; set; }

        public string Komentar { get; set; }

    }
}
