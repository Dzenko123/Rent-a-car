using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Lokacija")]
    public class Lokacija
    {
        [Key]
        public int Id { get; set; }

        public string Adresa { get; set; } = null!;

        public virtual ICollection<Grad> Gradovi { get; } = new List<Grad>();
    }
}
