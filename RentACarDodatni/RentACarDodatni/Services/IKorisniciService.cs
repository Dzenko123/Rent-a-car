using RentACar.Model.Requests;

namespace RentACar.Services.IServices
{
    public interface IKorisniciService 
    {
        Task<int?> GetLoged(string username, string password);

        public Task<Model.Models.Korisnici> Login(string username, string password);

    }
}
