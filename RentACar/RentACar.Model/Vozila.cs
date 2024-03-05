using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model
{
    public partial class Vozila
    {
        public int VoziloId { get; set; }
        public string Naziv { get; set; }
        public decimal Cijena { get; set; }
        public int TipVozilaId { get; set; }
        public byte[] Slika { get; set; }
    }
}
