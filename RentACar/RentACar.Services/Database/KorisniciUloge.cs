using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class KorisniciUloge
    {
        public int KorisnikUlogaId { get; set; }
        public int? UlogaId { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public int? KorisnikId { get; set; }

        public virtual Korisnici? Korisnik { get; set; }
    }
}
