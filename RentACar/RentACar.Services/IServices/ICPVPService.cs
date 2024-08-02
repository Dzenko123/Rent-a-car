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
    public interface ICPVPService : ICRUDService<CijenePoVremenskomPeriodu, CPVPSearchObject, CPVPInsertRequest, CPVPUpdateRequest, CPVPDeleteRequest>
    {
        Task<bool> DeleteByVoziloId(int voziloId);

    }
}
