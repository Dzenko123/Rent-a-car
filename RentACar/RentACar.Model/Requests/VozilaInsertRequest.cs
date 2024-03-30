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
        public int TipVozilaId { get; set; }


        public string? Marka { get; set; }

        public string? Model { get; set; }
        public byte[]? Slika { get; set; }


        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }
        public string Gorivo { get; set; }
        public double Kilometraza { get; set; }
    }
}
