using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class DodatnaUslugaInsertRequest
    {
        public string Naziv { get; set; }

        public decimal Cijena { get; set; }
    }
}
