using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class TipVozila
    {
        public int TipVozilaId { get; set; }

        public string? Tip { get; set; }

        public string? Opis { get; set; }

    }
}
