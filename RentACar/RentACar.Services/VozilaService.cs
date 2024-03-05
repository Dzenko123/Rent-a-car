using RentACar.Model;

namespace RentACar.Services
{
    public class VozilaService : IVozilaService
    {
        List<Vozila> vozilas = new List<Vozila>()
        {
            new Vozila()
            {
                VoziloId = 1,
                Naziv="Mercedes-Benz"
            }
        };
        public IList<Vozila> Get()
        {
            return vozilas;
        }
    }
}
