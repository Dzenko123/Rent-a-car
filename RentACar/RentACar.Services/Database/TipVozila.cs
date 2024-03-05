using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class TipVozila
    {
        public TipVozila()
        {
            Vozilos = new HashSet<Vozilo>();
        }

        public int TipVozilaId { get; set; }
        public string? Naziv { get; set; }

        public virtual ICollection<Vozilo> Vozilos { get; set; }
    }
}
