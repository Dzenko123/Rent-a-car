using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RentACar.Model.Models;

namespace RentACar.Services.TipVozilaStateMachine
{
    public interface IBaseState<TInsertRequest, TUpdateRequest>
    {
        Task<TipVozila> Insert(TInsertRequest request);
        Task<TipVozila> Update(int id, TUpdateRequest request);
    }

}
