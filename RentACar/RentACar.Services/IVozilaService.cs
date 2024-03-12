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
    public interface IVozilaService : ICRUDService<Vozila, VozilaSearchObject,VozilaInsertRequest, VozilaUpdateRequest>
    {
        Task<Vozila> Activate(int id);
        Task<Vozila> Hide(int id);
        Task<List<string>> AllowedActions(int id);
    }
}
