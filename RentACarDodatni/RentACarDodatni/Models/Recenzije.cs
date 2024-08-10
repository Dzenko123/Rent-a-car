using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class Recenzije
    {
        public int RecenzijaId { get; set; }

        public int KorisnikId { get; set; }

        public int VoziloId { get; set; }

        public bool IsLiked { get; set; }


    }
}
