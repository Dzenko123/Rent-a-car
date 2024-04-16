using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using RentACar.Model.Models;

namespace RentACar.Services
{
    public class MappingProfile:Profile
    {
        public MappingProfile() {
            CreateMap<Database.Korisnici, Korisnici>();
            CreateMap<Model.Requests.KorisniciInsertRequest, Database.Korisnici>();
            CreateMap<Model.Requests.KorisniciUpdateRequest, Database.Korisnici>();
            CreateMap<Model.Requests.KorisniciDeleteRequest, Database.Korisnici>();

            CreateMap<Database.Vozila, Vozila>();
            CreateMap<Model.Requests.VozilaInsertRequest, Database.Vozila>();
            CreateMap<Model.Requests.VozilaUpdateRequest, Database.Vozila>();
            CreateMap<Model.Requests.VozilaDeleteRequest, Database.Vozila>();
            //CreateMap<Model.Requests.VozilaUpdateRequest, Database.Vozila>()
                //.ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));  --> da možemo slati nullable vrijednosti

            CreateMap<Database.TipVozila, TipVozila>();
            CreateMap<Model.Requests.TipVozilaInsertRequest, Database.TipVozila>();
            CreateMap<Model.Requests.TipVozilaUpdateRequest, Database.TipVozila>();
            CreateMap<Model.Requests.TipVozilaDeleteRequest, Database.TipVozila>();

            CreateMap<Database.Kontakt, Kontakt>();
            CreateMap<Model.Requests.KontaktInsertRequest, Database.Kontakt>();
            CreateMap<Model.Requests.KontaktUpdateRequest, Database.Kontakt>();
            CreateMap<Model.Requests.KontaktDeleteRequest, Database.Kontakt>();

            CreateMap<Database.DodatnaUsluga, DodatnaUsluga>();
            CreateMap<Database.KorisniciUloge, KorisniciUloge>();
            CreateMap<Database.Uloge, Uloge>();


            CreateMap<Database.CijenePoVremenskomPeriodu, CijenePoVremenskomPeriodu>();
            CreateMap<Model.Requests.CPVPInsertRequest, Database.CijenePoVremenskomPeriodu>();
            CreateMap<Model.Requests.CPVPUpdateRequest, Database.CijenePoVremenskomPeriodu>();
            CreateMap<Model.Requests.CPVPDeleteRequest, Database.CijenePoVremenskomPeriodu>();

            CreateMap<Database.Period, Period>();
            CreateMap<Model.Requests.PeriodInsertRequest, Database.Period>();
            CreateMap<Model.Requests.PeriodUpdateRequest, Database.Period>();
            CreateMap<Model.Requests.PeriodDeleteRequest, Database.Period>();

            CreateMap<Database.Rezervacija, Rezervacija>();
            CreateMap<Model.Requests.RezervacijaInsertRequest, Database.Rezervacija>();
            CreateMap<Model.Requests.RezervacijaUpdateRequest, Database.Rezervacija>();
            CreateMap<Model.Requests.RezervacijaDeleteRequest, Database.Rezervacija>();
        }
    }
}
