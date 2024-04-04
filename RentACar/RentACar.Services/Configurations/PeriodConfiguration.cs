using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class PeriodConfiguration:BaseConfiguration<Period>
    {
        public override void Configure(EntityTypeBuilder<Period> builder)
        {
            base.Configure(builder);
            builder.HasKey(p => p.PeriodId);
            builder.Property(p => p.Trajanje).IsRequired();
        }
    }
}
