using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.VozilaStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{

    public class CPVPService:BaseCRUDService<CijenePoVremenskomPeriodu,Database.CijenePoVremenskomPeriodu,CPVPSearchObject,CPVPInsertRequest,CPVPUpdateRequest, CPVPDeleteRequest>,ICPVPService
    {

        public CPVPService(RentACarDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

       
    }
}
