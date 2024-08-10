using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class RezervacijaUpdateRequest
    {

        public int KorisnikId { get; set; }


        public int VoziloId { get; set; }


        public int? GradId { get; set; }


        public DateTime? PocetniDatum { get; set; }

        public DateTime? ZavrsniDatum { get; set; }

    }
}
