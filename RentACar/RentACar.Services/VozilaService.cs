using RentACar.Model;

namespace RentACar.Services
{
    public class VozilaService : IVozilaService
    {
        List<Vozilo> vozilas = new List<Vozilo>()
        {
            new Vozilo()
            {
                VoziloId = 1,
                Naziv="Mercedes-Benz"
            }
        };
        public IList<Vozilo> Get()
        {
            return vozilas;
        }
    }
}
