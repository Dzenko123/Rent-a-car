﻿namespace RentACar.Model.Models
{
    public class Korisnici
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public bool? Status { get; set; }

        public virtual ICollection<KorisniciUloge> KorisniciUloge { get; } = new List<KorisniciUloge>();

    }
}