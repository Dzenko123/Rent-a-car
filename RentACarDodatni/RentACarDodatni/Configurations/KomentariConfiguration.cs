using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class KomentariConfiguration: BaseConfiguration<Komentari>
    {
        public override void Configure(EntityTypeBuilder<Komentari> builder)
        {
            base.Configure(builder);
            builder.HasKey(k => k.KomentarId);

            builder.HasOne(k => k.Korisnik)
                   .WithMany()
                   .HasForeignKey(k => k.KorisnikId);

            builder.HasOne(k => k.Vozilo)
                   .WithMany(v => v.Komentari)
                   .HasForeignKey(k => k.VoziloId);
        }
    }
}
