using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
using RentACar.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.VozilaStateMachine
{
    public class BaseState
    {
        protected RentACarDBContext _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }

        public BaseState(IServiceProvider serviceProvider,RentACarDBContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider= serviceProvider;
        }

        public virtual Task<Model.Vozila> Insert(VozilaInsertRequest request)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.Vozila> Update(int id, VozilaUpdateRequest request)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.Vozila> Activate(int id)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.Vozila> Hide(int id)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.Vozila> Delete(int id)
        {
            throw new Exception("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return _serviceProvider.GetService<InitialVozilaState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftVozilaState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveVozilaState>();
                    break;
                default:
                    throw new Exception("Not allowed");
            }
        }
    }
}
