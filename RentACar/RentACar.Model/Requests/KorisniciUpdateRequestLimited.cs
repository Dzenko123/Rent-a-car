using System.ComponentModel.DataAnnotations;

namespace RentACar.Model.Requests
{
    public class KorisniciUpdateRequestLimited
    {
        public string? KorisnickoIme { get; set; } = null!;

        public string? Password { get; set; }

        [Compare("Password", ErrorMessage = "Passwords do not match")]
        public string? PasswordPotvrda { get; set; }
    }
}
