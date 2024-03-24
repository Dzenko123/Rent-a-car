using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class VoziloConfiguration:BaseConfiguration<Vozila>
    {
        public override void Configure(EntityTypeBuilder<Vozila> builder)
        {
            base.Configure(builder);
            builder.HasKey(v => v.VoziloId);
            builder.HasOne(v => v.TipVozila)
                   .WithMany()
                   .HasForeignKey(v => v.TipVozilaId);
        }
    }
}
