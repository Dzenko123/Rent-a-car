using System;
using System.Collections.Generic;

namespace RentACar.Services.Database
{
    public partial class Vozilo
    {
        public int VoziloId { get; set; }
        public int? TipVozilaId { get; set; }
        public string? Naziv { get; set; }
        public string? Marka { get; set; }
        public string? Model { get; set; }
        public string? Registrovan { get; set; }
        public int? Cijena { get; set; }
        public string? GodinaProizvodnje { get; set; }
        public byte[]? Slika { get; set; }
        public byte[]? SlikaThumb { get; set; }

        public virtual TipVozila? TipVozila { get; set; }
        public virtual ICollection<Narudzba> Narudzbas { get;} = new List<Narudzba>();
        public virtual ICollection<Ocjene> Ocjenes { get; } = new List<Ocjene>();
    }
}
