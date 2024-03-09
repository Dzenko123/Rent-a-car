using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{

    [Table("Grad")]
    public class Grad
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Lokacija")]
        public int LokacijaId { get; set; }

        public Lokacija Lokacija { get; set; } = null!;

        public string Naziv { get; set; } = null!;

        public string PostanskiBroj { get; set; } = null!;
    }
}
