using RentACar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public interface IVozilaService
    {
        IList<Vozila> Get();
    }
}
