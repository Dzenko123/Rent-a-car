using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("CijenePoVremenskomPeriodu")]
    public class CijenePoVremenskomPeriodu
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Vozilo")]
        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;

        public decimal Cijena { get; set; }

        public int BrojDana { get; set; }
    }
}
