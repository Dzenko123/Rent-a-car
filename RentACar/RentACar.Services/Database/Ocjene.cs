using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Ocjene
    {
        public int OcjenaId { get; set; }
        public int? VoziloId { get; set; }
        public int? KorisnikId { get; set; }
        public DateTime? Datum { get; set; }
        public int? Ocjena { get; set; }

        public virtual Korisnici? Korisnik { get; set; }
        public virtual Kupci? KorisnikNavigation { get; set; }
        public virtual Vozilo? Vozilo { get; set; }
    }
}
