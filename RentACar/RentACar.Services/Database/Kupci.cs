using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Kupci
    {
        public Kupci()
        {
            Narudzbas = new HashSet<Narudzba>();
            Ocjenes = new HashSet<Ocjene>();
        }

        public int KupacId { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public DateTime? DatumRegistracije { get; set; }
        public string? Email { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? LozinkaHash { get; set; }
        public string? LozinkaSalt { get; set; }
        public bool? Status { get; set; }

        public virtual ICollection<Narudzba> Narudzbas { get; set; }
        public virtual ICollection<Ocjene> Ocjenes { get; set; }
    }
}
