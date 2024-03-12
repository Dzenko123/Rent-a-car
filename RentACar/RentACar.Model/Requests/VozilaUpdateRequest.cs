using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class VozilaUpdateRequest
    {

        public byte[]? Slika { get; set; }

        public bool Dostupan { get; set; }

        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }
    }
}
