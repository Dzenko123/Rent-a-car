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
    public class VoziloPregledConfiguration : BaseConfiguration<VoziloPregled>
    {
        public override void Configure(EntityTypeBuilder<VoziloPregled> builder)
        {
            base.Configure(builder);
            builder.HasKey(vp => vp.VoziloPregledId);
            builder.HasOne(vp => vp.Vozilo)
                   .WithMany(vp => vp.VoziloPregled)
                   .HasForeignKey(vp => vp.VoziloId)
                   .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
