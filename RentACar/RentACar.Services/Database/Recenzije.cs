using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Recenzije")]
    public class Recenzije
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Korisnici")]
        public int KorisniciId { get; set; }

        public Korisnici Korisnici { get; set; } = null!;

        public int Ocjena { get; set; }

        public string Komentar { get; set; } = null!;

        public DateTime DatumVrijeme { get; set; }
    }
}
