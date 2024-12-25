using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class ToDo4924
    {
        public int ToDo4924Id { get; set; }
        public string NazivAktivnosti { get; set; }
        public string OpisAktivnosti { get; set; }
        public DateTime DatumIzvrsenja { get; set; }
        public string Status { get; set; }
        public int KorisnikId { get; set; }
        public Korisnici Korisnik { get; set; }
    }
}
