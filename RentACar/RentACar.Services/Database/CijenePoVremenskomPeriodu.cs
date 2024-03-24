using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class CijenePoVremenskomPeriodu
    {
        public int CijenePoVremenskomPerioduId { get; set; }

        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;
        public DateTime DatumPocetak { get; set; }
        public DateTime DatumKraj { get; set; }

        public decimal Cijena { get; set; }
    }
}
