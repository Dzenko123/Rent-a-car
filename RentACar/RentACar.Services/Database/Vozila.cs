using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Vozila")]
    public class Vozila
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("TipVozila")]
        public int TipVozilaId { get; set; }

        public TipVozila TipVozila { get; set; } = null!;

        public byte[]? Slika { get; set; }

        public bool Dostupan { get; set; }

        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }
        public string? StateMachine { get; set; }

        public virtual ICollection<Recenzije> Recenzije { get; } = new List<Recenzije>();
        public virtual ICollection<CijenePoVremenskomPeriodu> CijenePoVremenskomPeriodu { get; } = new List<CijenePoVremenskomPeriodu>();

    }
}
