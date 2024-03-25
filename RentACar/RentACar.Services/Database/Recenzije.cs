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

        public int KorisniciId { get; set; }
        public Korisnici Korisnici { get; set; } = null!;

        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;

        public int Ocjena { get; set; }

        public string Komentar { get; set; } = null!;

        public DateTime DatumVrijeme { get; set; }

    }
}
