using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("KorisniciUloge")]
    public class KorisniciUloge
    {
        [Key]
        public int KorisnikUlogaId { get; set; }

        [ForeignKey("Korisnik")]
        public int KorisnikId { get; set; }

        [ForeignKey("Uloga")]
        public int UlogaId { get; set; }

        public DateTime DatumIzmjene { get; set; }

        public virtual Korisnici Korisnik { get; set; } = null!;

        public virtual Uloge Uloga { get; set; } = null!;
    }
}
