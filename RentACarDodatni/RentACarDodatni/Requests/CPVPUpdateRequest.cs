using RentACar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class CPVPUpdateRequest
    {

        public int VoziloId { get; set; }

        public int PeriodId { get; set; }


        public decimal? Cijena { get; set; }
    }
}