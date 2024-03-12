using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Racun")]
    public class Racun
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Rezervacija")]
        public int RezervacijaId { get; set; }

        public Rezervacija Rezervacija { get; set; } = null!;

        public decimal UkupnaCijena { get; set; }

        public virtual ICollection<Transakcija> Transakcije { get; } = new List<Transakcija>();
    }
}
