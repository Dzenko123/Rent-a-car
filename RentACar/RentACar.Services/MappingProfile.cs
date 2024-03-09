using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace RentACar.Services
{
    public class MappingProfile:Profile
    {
        public MappingProfile() {
            CreateMap<Database.Korisnici, Model.Korisnici>();
            CreateMap<Model.Requests.KorisniciInsertRequest, Database.Korisnici>();
            CreateMap<Model.Requests.KorisniciUpdateRequest, Database.Korisnici>();


            CreateMap<Database.TipVozila, Model.TipVozila>();
            CreateMap<Database.DodatnaUsluga, Model.DodatnaUsluga>();

        }
    }
}
