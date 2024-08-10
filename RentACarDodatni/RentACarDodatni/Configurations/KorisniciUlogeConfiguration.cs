using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class KorisniciUlogeConfiguration : BaseConfiguration<KorisniciUloge>
    {
        public override void Configure(EntityTypeBuilder<KorisniciUloge> builder)
        {
            base.Configure(builder);

            builder.HasKey(e => e.KorisnikUlogaId);


            builder.HasOne(ku => ku.Korisnik)
                   .WithMany(k => k.KorisniciUloge)
                   .HasForeignKey(ku => ku.KorisnikId);

            builder.HasOne(ku => ku.Uloga)
                   .WithMany(u => u.KorisniciUloges)
                   .HasForeignKey(ku => ku.UlogaId);
        }
    }
}