using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class VoziloPregledUpdateRequest
    {
        public int VoziloId { get; set; }
        public DateTime Datum { get; set; }
    }
}
