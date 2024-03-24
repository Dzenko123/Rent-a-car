using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Transakcija
    {
        public int TransakcijaId { get; set; }

        public int RacunId { get; set; }

        public Racun Racun { get; set; } = null!;
        public double Iznos { get; set; }
        public bool Status { get; set; }
        public DateTime DatumVrijeme { get; set; }
    }
}
