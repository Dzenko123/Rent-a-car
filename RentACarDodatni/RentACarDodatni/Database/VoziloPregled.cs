using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class VoziloPregled
    {
        public int VoziloPregledId { get; set; }
        public int VoziloId { get; set; }
        public Vozila Vozilo { get; set; }
        public DateTime Datum { get; set; }
    }
}
