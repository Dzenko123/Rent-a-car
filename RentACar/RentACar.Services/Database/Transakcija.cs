using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Transakcija")]
    public class Transakcija
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Racun")]
        public int RacunId { get; set; }

        public Racun Racun { get; set; } = null!;

        public string? TipPlacanja { get; set; }

        public DateTime DatumVrijeme { get; set; }
    }
}
