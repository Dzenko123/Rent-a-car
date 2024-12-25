using RentACar.Model.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Requests
{
    public class ToDo4924UpdateRequest
    {
        public string NazivAktivnosti { get; set; }
        public string OpisAktivnosti { get; set; }
        public DateTime DatumIzvrsenja { get; set; }
        public string Status { get; set; }
        public int KorisnikId { get; set; }
    }
}
