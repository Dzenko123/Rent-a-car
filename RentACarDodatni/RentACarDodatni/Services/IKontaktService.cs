using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.IServices
{
    public interface IKontaktService
    {
        Task<List<Kontakt>> Get(KontaktSearchObject searchObject);
        Task<Kontakt> GetById(int id);
        Task<Kontakt> Post(KontaktInsertRequest request);
    }
}
