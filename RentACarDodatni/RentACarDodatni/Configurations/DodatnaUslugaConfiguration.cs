using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class DodatnaUslugaConfiguration:BaseConfiguration<DodatnaUsluga>
    {
        public override void Configure(EntityTypeBuilder<DodatnaUsluga> builder)
        {
            base.Configure(builder);
            builder.HasKey(du => du.DodatnaUslugaId);
           
        }
    }
}
