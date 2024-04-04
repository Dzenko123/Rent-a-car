using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class KontaktUpdateRequest
    {
        public int KorisnikId { get; set; }

        public string ImePrezime { get; set; }
        public string Poruka { get; set; }

        public string Telefon { get; set; }

        public string Email { get; set; }
    }
}
