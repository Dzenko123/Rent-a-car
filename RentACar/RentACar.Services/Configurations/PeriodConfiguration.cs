using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;

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
