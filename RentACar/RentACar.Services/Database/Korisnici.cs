using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Korisnici
    {
        public Korisnici()
        {
            Izlazis = new HashSet<Izlazi>();
            Kontakts = new HashSet<Kontakt>();
            KorisniciUloges = new HashSet<KorisniciUloge>();
            Ocjenes = new HashSet<Ocjene>();
            Ulazis = new HashSet<Ulazi>();
        }

        public int KorisnikId { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? Email { get; set; }
        public string? Telefon { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? LozinkaHash { get; set; }
        public string? LozinkaSalt { get; set; }
        public bool? Status { get; set; }

        public virtual ICollection<Izlazi> Izlazis { get; set; }
        public virtual ICollection<Kontakt> Kontakts { get; set; }
        public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; }
        public virtual ICollection<Ocjene> Ocjenes { get; set; }
        public virtual ICollection<Ulazi> Ulazis { get; set; }
    }
}
