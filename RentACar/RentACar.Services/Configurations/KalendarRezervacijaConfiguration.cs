using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class KalendarRezervacijaConfiguration:BaseConfiguration<KalendarRezervacija>
    {
        public override void Configure(EntityTypeBuilder<KalendarRezervacija> builder)
        {
            base.Configure(builder);
            builder.HasKey(k => k.KalendarRezervacijaId);
            builder.HasOne(k => k.Vozilo)
                   .WithMany()
                   .HasForeignKey(k => k.VoziloId);
        }
    }
}
