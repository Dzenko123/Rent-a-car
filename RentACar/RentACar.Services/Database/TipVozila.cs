using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class TipVozila
    {

        public int TipVozilaId { get; set; }
        public string? Naziv { get; set; }

        public virtual ICollection<Vozilo> Vozilos { get; } = new List<Vozilo>();
    }
}
