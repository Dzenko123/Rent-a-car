using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class UlogeConfiguration:BaseConfiguration<Uloge>
    {
        public override void Configure(EntityTypeBuilder<Uloge> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.UlogaId);

            builder.HasMany(u => u.KorisniciUloges)
                   .WithOne(ku => ku.Uloga)
                   .HasForeignKey(ku => ku.UlogaId);
        }
    }
}
