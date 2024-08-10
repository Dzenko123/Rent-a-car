using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Configurations;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class GorivoConfiguration: BaseConfiguration<Gorivo>
    {
        public override void Configure(EntityTypeBuilder<Gorivo> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.GorivoId);

        }
    }
}
