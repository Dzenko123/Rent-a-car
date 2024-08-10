using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.SearchObject
{
    public class CPVPSearchObject:BaseSearchObject
    {
        public int VoziloId { get; set; }
        public bool? IsPeriodIncluded { get; set; }

    }
}
