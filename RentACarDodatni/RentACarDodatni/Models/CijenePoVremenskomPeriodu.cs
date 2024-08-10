using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class CijenePoVremenskomPeriodu
    {
        public int CijenePoVremenskomPerioduId { get; set; }

        public int VoziloId { get; set; }


        public decimal Cijena { get; set; }

        public int PeriodId { get; set; }
        public virtual Period Period { get; set; } = null!;

    }
}
