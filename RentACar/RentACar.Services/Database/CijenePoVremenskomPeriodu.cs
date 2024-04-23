namespace RentACar.Services.Database
{
    public class CijenePoVremenskomPeriodu
    {
        public int CijenePoVremenskomPerioduId { get; set; }

        public int VoziloId { get; set; }

        public Vozila Vozilo { get; set; } = null!;

        public decimal Cijena { get; set; }

        public int PeriodId { get; set; }
        public Period Period { get; set; } = null!;
    }
}
