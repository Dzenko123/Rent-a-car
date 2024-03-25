using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class LajkoviConfiguration : BaseConfiguration<Lajkovi>
    {
        public override void Configure(EntityTypeBuilder<Lajkovi> builder)
        {
            base.Configure(builder);
            builder.HasKey(l => l.LajkId);

            builder.HasOne(ov => ov.Vozilo)
            .WithMany(l => l.Lajkovi)
            .HasForeignKey(ov => ov.VoziloId)
            .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(ov => ov.Korisnik)
                   .WithMany()
                   .HasForeignKey(ov => ov.KorisnikId)
                   .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
