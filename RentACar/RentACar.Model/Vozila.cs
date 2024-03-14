using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model
{
    public class Vozila
    {
        [Key]
        public int VoziloId { get; set; }

        [ForeignKey("TipVozila")]
        public int TipVozilaId { get; set; }


        public byte[]? Slika { get; set; }

        public bool Dostupan { get; set; }

        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }
        public string StateMachine { get; set; }

    }
}
