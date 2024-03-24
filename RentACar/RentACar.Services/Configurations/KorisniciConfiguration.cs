using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;

namespace RentACar.Services.Configurations
{
    public class KorisniciConfiguration : BaseConfiguration<Korisnici>
    {
        public override void Configure(EntityTypeBuilder<Korisnici> builder)
        {
            base.Configure(builder);

            builder.HasKey(e => e.KorisnikId);

            builder.HasMany(k => k.KorisniciUloge)
                   .WithOne(ku => ku.Korisnik)
                   .HasForeignKey(ku => ku.KorisnikId);
        }
    }
}
