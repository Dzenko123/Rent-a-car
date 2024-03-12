using AutoMapper;
using RentACar.Model;
using RentACar.Model.Requests;

namespace RentACar.Services.VozilaStateMachine
{
    public class ActiveVozilaState : BaseState
    {
        public ActiveVozilaState(IServiceProvider serviceProvider, RentACarDBContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

    }
}
