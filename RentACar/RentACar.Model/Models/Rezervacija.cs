using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.Models
{
    public class Rezervacija
    {
        public int RezervacijaId { get; set; }

        public int KorisnikId { get; set; }


        public int VoziloId { get; set; }


        public int GradId { get; set; }


        public DateTime PocetniDatum { get; set; }

        public DateTime ZavrsniDatum { get; set; }
        public ICollection<RezervacijaDodatnaUsluga> DodatnaUsluga { get; set; }= new List<RezervacijaDodatnaUsluga>();

    }
}
