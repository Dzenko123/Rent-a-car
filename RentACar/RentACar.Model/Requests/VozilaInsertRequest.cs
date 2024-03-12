using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class VozilaInsertRequest
    {

        [ForeignKey("TipVozila")]
        public int TipVozilaId { get; set; }
        public byte[]? Slika { get; set; }

        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }
    }
}
