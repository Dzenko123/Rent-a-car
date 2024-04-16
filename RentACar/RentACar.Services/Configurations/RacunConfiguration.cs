using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class RacunConfiguration:BaseConfiguration<Racun>
    {
        public override void Configure(EntityTypeBuilder<Racun> builder)
        {
            base.Configure(builder);
            builder.HasKey(e => e.RacunId);

            builder.HasOne(r => r.TipPlacanja)
                .WithMany()
                .HasForeignKey(r => r.TipPlacanjaId)
                .IsRequired();
        }
    }
}
