using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model
{
    public class DodatnaUsluga
    {
        [Key]
        public int Id { get; set; }

        public string Naziv { get; set; } = null!;

        public decimal Cijena { get; set; }
    }
}
