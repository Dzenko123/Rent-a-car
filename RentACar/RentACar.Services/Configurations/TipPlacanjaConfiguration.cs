using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class TipPlacanjaConfiguration : BaseConfiguration<TipPlacanja>
    {
        public override void Configure(EntityTypeBuilder<TipPlacanja> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.TipPlacanjaId);
        }
    }
}
