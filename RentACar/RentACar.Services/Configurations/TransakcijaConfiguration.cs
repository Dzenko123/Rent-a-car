using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class TransakcijaConfiguration : BaseConfiguration<Transakcija>
    {
        public override void Configure(EntityTypeBuilder<Transakcija> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.TransakcijaId);

            builder.HasOne(t => t.Racun)
            .WithMany(r => r.Transakcije)
            .HasForeignKey(t => t.RacunId);
        }
    }
}
