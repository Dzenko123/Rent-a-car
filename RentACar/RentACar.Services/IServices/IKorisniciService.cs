using RentACar.Model.Requests;

namespace RentACar.Services.IServices
{
    public interface IKorisniciService : ICRUDService<Model.Models.Korisnici, Model.SearchObject.KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest, KorisniciDeleteRequest>
    {
        Task<int?> GetLoged(string username, string password);

        public Task<Model.Models.Korisnici> Login(string username, string password);
        public Task UpdatePasswordAndUsername(int id, KorisniciUpdateRequestLimited request);
        Task<bool> VerifyOldPassword(int id, string oldPassword);

    }
}
