﻿using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Requests;
using RentACar.Services;
using RentACar.Model;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VozilaController : BaseCRUDController<Vozila, Model.SearchObject.VozilaSearchObject, Model.Requests.VozilaInsertRequest, Model.Requests.VozilaUpdateRequest>
    {
        public VozilaController(ILogger<BaseController<Vozila, Model.SearchObject.VozilaSearchObject>> logger,
                IVozilaService service) : base(logger, service)
        {
        }
        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Vozila> Activate(int id)
        {
            return await (_service as IVozilaService).Activate(id);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<Model.Vozila> Hide(int id)
        {
            return await (_service as IVozilaService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IVozilaService).AllowedActions(id);

        }
    }
}