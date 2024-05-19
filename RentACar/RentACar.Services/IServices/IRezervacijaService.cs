using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.IServices
{
    public interface IRezervacijaService : ICRUDService<Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest, RezervacijaDeleteRequest>
    {
        Task<IEnumerable<Rezervacija>> GetByKorisnikId(int korisnikId);
    }
}
