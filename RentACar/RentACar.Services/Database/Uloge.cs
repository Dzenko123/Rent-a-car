using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Uloge")]
    public class Uloge
    {
        [Key]
        public int UlogaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public List<KorisniciUloge> KorisniciUloges { get; set; } = new List<KorisniciUloge>();
    }
}
