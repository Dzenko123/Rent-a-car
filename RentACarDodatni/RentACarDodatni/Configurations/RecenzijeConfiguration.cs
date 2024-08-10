using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class RecenzijeConfiguration:BaseConfiguration<Recenzije>
    {
        public override void Configure(EntityTypeBuilder<Recenzije> builder)
        {
            base.Configure(builder);
            builder.HasKey(r => r.RecenzijaId);

            builder.HasOne(r => r.Korisnik)
                   .WithMany()
                   .HasForeignKey(r => r.KorisnikId);

            builder.HasOne(r => r.Vozilo)
                   .WithMany(v => v.Recenzije)
                   .HasForeignKey(r => r.VoziloId);
        }
    }
}
