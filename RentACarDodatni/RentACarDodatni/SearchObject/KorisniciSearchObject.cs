namespace RentACar.Model.SearchObject
{
    public class KorisniciSearchObject : BaseSearchObject
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public bool? IsUlogeIncluded { get; set; } 
    }
}
