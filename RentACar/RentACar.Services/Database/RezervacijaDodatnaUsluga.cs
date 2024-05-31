using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class RezervacijaDodatnaUsluga
    {
        public int RezervacijaId { get; set; }
        public Rezervacija Rezervacija { get; set; } = null!;

        public int DodatnaUslugaId { get; set; }
        public DodatnaUsluga DodatnaUsluga { get; set; } = null!;
    }
}
