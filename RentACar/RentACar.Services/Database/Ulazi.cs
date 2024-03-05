using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Ulazi
    {
        public int UlazId { get; set; }
        public string? BrojFakture { get; set; }
        public DateTime? Datum { get; set; }
        public decimal? IznosRacuna { get; set; }
        public decimal? Pdv { get; set; }
        public string? Napomena { get; set; }
        public int? KorisnikId { get; set; }

        public virtual Korisnici? Korisnik { get; set; }
    }
}
