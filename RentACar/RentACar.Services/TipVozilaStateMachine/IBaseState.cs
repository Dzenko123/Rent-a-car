using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.TipVozilaStateMachine
{
    public interface IBaseState<TInsertRequest, TUpdateRequest>
    {
        Task<Model.TipVozila> Insert(TInsertRequest request);
        Task<Model.TipVozila> Update(int id, TUpdateRequest request);
    }

}
