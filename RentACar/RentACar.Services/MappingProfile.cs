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

            CreateMap<Database.Vozila, Model.Vozila>();
            CreateMap<Model.Requests.VozilaInsertRequest, Database.Vozila>();
            CreateMap<Model.Requests.VozilaUpdateRequest, Database.Vozila>();
            //CreateMap<Model.Requests.VozilaUpdateRequest, Database.Vozila>()
                //.ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));  --> da možemo slati nullable vrijednosti

            CreateMap<Database.TipVozila, Model.TipVozila>();
            CreateMap<Model.Requests.TipVozilaInsertRequest, Database.TipVozila>();
            CreateMap<Model.Requests.TipVozilaUpdateRequest, Database.TipVozila>();

            CreateMap<Database.Kontakt, Model.Kontakt>();
            CreateMap<Model.Requests.KontaktInsertRequest, Database.Kontakt>();
            CreateMap<Model.Requests.KontaktUpdateRequest, Database.Kontakt>();

            CreateMap<Database.DodatnaUsluga, Model.DodatnaUsluga>();
            CreateMap<Database.KorisniciUloge, Model.KorisniciUloge>();
            CreateMap<Database.Uloge, Model.Uloge>();


            CreateMap<Database.CijenePoVremenskomPeriodu, Model.CijenePoVremenskomPeriodu>();
            CreateMap<Model.Requests.CPVPInsertRequest, Database.CijenePoVremenskomPeriodu>();
            CreateMap<Model.Requests.CPVPUpdateRequest, Database.CijenePoVremenskomPeriodu>();

            CreateMap<Database.Period, Model.Period>();
            CreateMap<Model.Requests.PeriodInsertRequest, Database.Period>();
            CreateMap<Model.Requests.PeriodUpdateRequest, Database.Period>();
        }
    }
}
