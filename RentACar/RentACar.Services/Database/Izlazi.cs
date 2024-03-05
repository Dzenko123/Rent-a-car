using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Izlazi
    {
        public int IzlazId { get; set; }
        public string? BrojRacuna { get; set; }
        public DateTime? Datum { get; set; }
        public int? KorisnikId { get; set; }
        public decimal? IznosBezPdv { get; set; }
        public decimal? IznosSaPdv { get; set; }
        public int? NarudbaId { get; set; }

        public virtual Korisnici? Korisnik { get; set; }
        public virtual Narudzba? Narudba { get; set; }

        public virtual ICollection<Narudzba> Narudzbas { get; } = new List<Narudzba>();
    }
}
