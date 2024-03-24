using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class LokacijaConfiguration:BaseConfiguration<Lokacija>
    {
        public override void Configure(EntityTypeBuilder<Lokacija> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.LokacijaId);
            builder.HasOne(l => l.Grad)
                   .WithMany(g => g.Lokacija)
                   .HasForeignKey(l => l.GradId);
        }
    }
}
