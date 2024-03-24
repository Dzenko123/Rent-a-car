using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Lokacija
    {
        public int LokacijaId { get; set; }
        public Grad Grad { get; set; }
        public int GradId { get; set; }
        public string Naziv { get; set; }

        public string Adresa { get; set; } = null!;
    }
}
