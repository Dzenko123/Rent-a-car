using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using RentACar.Model.Models;
namespace RentACar.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
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
            CreateMap<Database.VoziloPregled, VoziloPregled>();
            CreateMap<Model.Requests.VoziloPregledInsertRequest, Database.VoziloPregled>();
            CreateMap<Model.Requests.VoziloPregledUpdateRequest, Database.VoziloPregled>();
            CreateMap<Model.Requests.VoziloPregledDeleteRequest, Database.VoziloPregled>();
            CreateMap<Database.Gorivo, Gorivo>();
            CreateMap<Model.Requests.GorivoInsertRequest, Database.Gorivo>();
            CreateMap<Model.Requests.GorivoUpdateRequest, Database.Gorivo>();
            CreateMap<Model.Requests.GorivoDeleteRequest, Database.Gorivo>();

            CreateMap<Database.Recenzije, Recenzije>();
            CreateMap<Model.Requests.RecenzijeInsertRequest, Database.Recenzije>();
            CreateMap<Model.Requests.RecenzijeUpdateRequest, Database.Recenzije>();
            CreateMap<Model.Requests.RecenzijeDeleteRequest, Database.Recenzije>();


            CreateMap<Database.RezervacijaDodatnaUsluga, RezervacijaDodatnaUsluga>();
            CreateMap<Model.Requests.RezervacijaDodatnaUslugaInsertRequest, Database.RezervacijaDodatnaUsluga>();
            CreateMap<Model.Requests.RezervacijaDodatnaUslugaUpdateRequest, Database.RezervacijaDodatnaUsluga>();
            CreateMap<Model.Requests.RezervacijaDodatnaUslugaDeleteRequest, Database.RezervacijaDodatnaUsluga>();

            CreateMap<Database.Komentari, Komentari>();
            CreateMap<Model.Requests.KomentariInsertRequest, Database.Komentari>();
            CreateMap<Model.Requests.KomentariUpdateRequest, Database.Komentari>();
            CreateMap<Model.Requests.KomentariDeleteRequest, Database.Komentari>();
            //        CreateMap<Database.Komentari, Komentari>()
            //.ForMember(dest => dest.VoziloId, opt => opt.MapFrom(src => Convert.ToInt32(src.VoziloId)));
            CreateMap<Database.Kontakt, Kontakt>();
            CreateMap<Model.Requests.KontaktInsertRequest, Database.Kontakt>();
            CreateMap<Model.Requests.KontaktUpdateRequest, Database.Kontakt>();
            CreateMap<Model.Requests.KontaktDeleteRequest, Database.Kontakt>();

            CreateMap<Database.ToDo4924, ToDo4924>();
            CreateMap<Model.Requests.ToDo4924InsertRequest, Database.ToDo4924>();
            CreateMap<Model.Requests.ToDo4924UpdateRequest, Database.ToDo4924>();
            CreateMap<Model.Requests.ToDo4924DeleteRequest, Database.ToDo4924>();

            CreateMap<Database.ToDo4924, ToDo4924>()
    .ForMember(dest => dest.Korisnik, opt => opt.MapFrom(src => src.Korisnik));

            CreateMap<Database.KorisniciUloge, KorisniciUloge>();
            CreateMap<Database.Uloge, Uloge>();

            CreateMap<Database.DodatnaUsluga, DodatnaUsluga>();
            CreateMap<Model.Requests.DodatnaUslugaInsertRequest, Database.DodatnaUsluga>();
            CreateMap<Model.Requests.DodatnaUslugaUpdateRequest, Database.DodatnaUsluga>();
            CreateMap<Model.Requests.DodatnaUslugaDeleteRequest, Database.DodatnaUsluga>();

            CreateMap<Database.Grad, Grad>();
            CreateMap<Model.Requests.GradInsertRequest, Database.Grad>();
            CreateMap<Model.Requests.GradUpdateRequest, Database.Grad>();
            CreateMap<Model.Requests.GradDeleteRequest, Database.Grad>();

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

            CreateMap<Database.Rezervacija, Rezervacija>()
           .ForMember(dest => dest.DodatnaUsluga, opt => opt.MapFrom(src => src.DodatnaUsluga));
            CreateMap<Database.RezervacijaDodatnaUsluga, RezervacijaDodatnaUsluga>();
            CreateMap<Database.DodatnaUsluga, DodatnaUsluga>();
        }
    }
}