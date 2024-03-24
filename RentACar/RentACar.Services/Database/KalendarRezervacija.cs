using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class KalendarRezervacija
    {
        public int KalendarRezervacijaId { get; set; }
        public int VoziloId { get; set; }
        public Vozila Vozilo { get; set; } = null!;
        public DateTime Datum { get; set; }
        public string Stanje { get; set; }
    }
}
