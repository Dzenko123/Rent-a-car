using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Kontakt
    {
        public int KontaktId { get; set; }
        public int? KorisnikId { get; set; }
        public string? Adresa { get; set; }
        public string? Telefon { get; set; }
        public string? Email { get; set; }

        public virtual Korisnici? Korisnik { get; set; }
    }
}
