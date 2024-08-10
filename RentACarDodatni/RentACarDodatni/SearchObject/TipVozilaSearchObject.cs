using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.SearchObject
{
    public class TipVozilaSearchObject : BaseSearchObject
    {
        public string? Marka { get; set; }
        public string? FTS { get; set; }
    }
}
