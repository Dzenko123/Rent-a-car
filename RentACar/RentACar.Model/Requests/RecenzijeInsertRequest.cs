using RentACar.Model.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class RecenzijeInsertRequest
    {
        public int KorisnikId { get; set; }

        public int VoziloId { get; set; }

        public bool IsLiked { get; set; }

    }
}
