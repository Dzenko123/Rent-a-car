using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("RezervacijaDodatnaUsluga")]
    public class RezervacijaDodatnaUsluga
    {
        [Key]
        public int RezervacijaId { get; set; }

        public Rezervacija Rezervacija { get; set; } = null!;

        public int DodatnaUslugaId { get; set; }

        public DodatnaUsluga DodatnaUsluga { get; set; } = null!;
    }
}
