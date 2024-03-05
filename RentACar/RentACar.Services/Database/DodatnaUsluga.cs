using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class DodatnaUsluga
    {
        public DodatnaUsluga()
        {
            Narudzbas = new HashSet<Narudzba>();
        }

        public int DodatnaUslugaId { get; set; }
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
        public int? Cijena { get; set; }

        public virtual ICollection<Narudzba> Narudzbas { get; set; }
    }
}
