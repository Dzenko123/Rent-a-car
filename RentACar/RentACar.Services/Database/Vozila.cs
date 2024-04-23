namespace RentACar.Services.Database
{
    public class Vozila
    {
        public int VoziloId { get; set; }

        public int TipVozilaId { get; set; }
        public TipVozila TipVozila { get; set; }

        public int GorivoId { get; set; }
        public Gorivo TipGoriva { get; set; }


        public string? Marka { get; set; }

        public string? Model { get; set; }

        public byte[]? Slika { get; set; }

        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }

        public double Kilometraza { get; set; }


        public string? StateMachine { get; set; }

        public virtual ICollection<Recenzije> Recenzije { get; } = new List<Recenzije>();
        public virtual ICollection<CijenePoVremenskomPeriodu> CijenePoVremenskomPeriodu { get; } = new List<CijenePoVremenskomPeriodu>();
        public virtual ICollection<Lajkovi> Lajkovi { get; set; } = new List<Lajkovi>();
    }
}
