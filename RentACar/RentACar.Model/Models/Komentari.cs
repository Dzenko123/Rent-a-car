using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class Komentari
    {
        public int KomentarId { get; set; }
        public int KorisnikId { get; set; }

        public int VoziloId { get; set; }

        public string Komentar { get; set; }

    }
}
