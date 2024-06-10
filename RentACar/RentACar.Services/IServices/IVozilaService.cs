using RentACar.Model;
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

    public interface IVozilaService : ICRUDService<Vozila, VozilaSearchObject, VozilaInsertRequest, VozilaUpdateRequest, VozilaDeleteRequest>
    {
        Task<Vozila> Activate(int id);
        Task<Vozila> Hide(int id);
        Task<List<string>> AllowedActions(int id);
        Task<PagedResult<Vozila>> GetActiveVehicles(VozilaSearchObject search);
        Task<Vozila> GetActiveVehicleById(int id);

    }
}