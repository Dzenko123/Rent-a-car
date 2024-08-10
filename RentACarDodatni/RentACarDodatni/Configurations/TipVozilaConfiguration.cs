using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class TipVozilaConfiguration:BaseConfiguration<TipVozila>
    {
        public override void Configure(EntityTypeBuilder<TipVozila> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.TipVozilaId);

        }
    }
}
