using RentACar.Model;
using RentACar.Services.Database;

namespace RentACar.Services
{
    public class VozilaService : IVozilaService
    {
        IB200149Context _context;

        public VozilaService(IB200149Context context)
        {
            _context= context;
        }

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
            var list=_context.Vozilos.ToList();
            return vozilas;
        }
    }
}
