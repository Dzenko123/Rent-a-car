﻿using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.IServices
{
    public interface IGorivoService : ICRUDService<Gorivo, GorivoSearchObject, GorivoInsertRequest, GorivoUpdateRequest, GorivoDeleteRequest>
    {
    }
}
