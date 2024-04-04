using RentACar.Model;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public interface IKontaktService : ICRUDService<Kontakt,KontaktSearchObject,KontaktInsertRequest,KontaktUpdateRequest>
    {
    }
}
