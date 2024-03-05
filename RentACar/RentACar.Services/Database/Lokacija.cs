using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Lokacija
    {
        public Lokacija()
        {
            Narudzbas = new HashSet<Narudzba>();
        }

        public int LokacijaId { get; set; }
        public string? Grad { get; set; }
        public string? Adresa { get; set; }

        public virtual ICollection<Narudzba> Narudzbas { get; set; }
    }
}
