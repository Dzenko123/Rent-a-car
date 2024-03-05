using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Narudzba
    {

        public int NarudzbaId { get; set; }
        public string? BrojNarudzbe { get; set; }
        public int? KupacId { get; set; }
        public int? VoziloId { get; set; }
        public int? GradId { get; set; }
        public DateTime? PocetniDatum { get; set; }
        public DateTime? ZavrsniDatum { get; set; }
        public bool? Status { get; set; }
        public bool? Otkazano { get; set; }

        public virtual Lokacija? Grad { get; set; }
        public virtual Kupci? Kupac { get; set; }
        public virtual Vozilo? Vozilo { get; set; }
        public virtual ICollection<Izlazi> Izlazis { get; } = new List<Izlazi>();

        public virtual ICollection<DodatnaUsluga> DodatnaUslugas { get; } = new List<DodatnaUsluga>();
        public virtual ICollection<Izlazi> Izlazs { get; } = new List<Izlazi>();
    }
}
