using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.Database;
using RentACar.Services.IServices;
using RentACar.Services.VozilaStateMachine;

namespace RentACar.Services.Services
{

    public class TipVozilaService : BaseCRUDService<Model.Models.TipVozila, TipVozila, TipVozilaSearchObject, TipVozilaInsertRequest, TipVozilaUpdateRequest, TipVozilaDeleteRequest>, ITipVozilaService
    {

        public TipVozilaService(RentACarDBContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

    }
}
