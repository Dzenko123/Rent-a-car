using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    public class Racun
    {
        public int RacunId { get; set; }

        public string TipPlacanja { get; set; }


        public decimal UkupnaCijena { get; set; }

        public virtual ICollection<Transakcija> Transakcije { get; } = new List<Transakcija>();
    }
}
