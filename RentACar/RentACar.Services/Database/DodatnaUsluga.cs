using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class DodatnaUsluga
    {
        public int DodatnaUslugaId { get; set; }

        public string Naziv { get; set; }

        public decimal Cijena { get; set; }
        public ICollection<RezervacijaDodatnaUsluga> Rezervacija { get; set; } = null!;

    }
}
