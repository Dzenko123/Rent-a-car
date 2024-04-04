using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class CijenePoVremenskomPerioduConfiguration:BaseConfiguration<CijenePoVremenskomPeriodu>
    {
        public override void Configure(EntityTypeBuilder<CijenePoVremenskomPeriodu> builder)
        {
            base.Configure(builder);
            builder.HasKey(c => c.CijenePoVremenskomPerioduId);
            builder.HasOne(c => c.Vozilo)
                   .WithMany(v => v.CijenePoVremenskomPeriodu)
                   .HasForeignKey(c => c.VoziloId);
            builder.HasOne(c => c.Period)
                   .WithMany()
                   .HasForeignKey(c => c.PeriodId);
        }
    }
}
