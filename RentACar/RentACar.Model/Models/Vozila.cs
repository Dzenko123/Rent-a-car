using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class Vozila
    {
        public int VoziloId { get; set; }

        public int TipVozilaId { get; set; }
        public int GorivoId { get; set; }

        public string? Marka { get; set; }

        public string? Model { get; set; }
        public byte[]? Slika { get; set; }


        public string? Motor { get; set; }

        public int GodinaProizvodnje { get; set; }

        public double Kilometraza { get; set; }


        public string StateMachine { get; set; }


    }
}
