using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace RentACar.Services.IServices
{
    public interface IRezervacijaService : ICRUDService<Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest, RezervacijaDeleteRequest>
    {
        Task<IEnumerable<Rezervacija>> GetByKorisnikId(int korisnikId);
        Task<Rezervacija> InsertRezervacijaWithDodatneUsluge(RezervacijaInsertRequest request);
        List<Model.Models.Rezervacija> Recommend(int id);

        Task<bool> Otkazivanje(int rezervacijaId);
        Task<bool> Potvrda(int rezervacijaId);

        Task<bool> GradIsInUse(int gradId);
        Task<bool> DodatnaUslugaIsInUse(int dodatnaUslugaId);
    }
}
