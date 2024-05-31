using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class RezervacijaDodatnaUslugaInsertRequest
    {
        public int RezervacijaId { get; set; }

        public int DodatnaUslugaId { get; set; }
    }
}
