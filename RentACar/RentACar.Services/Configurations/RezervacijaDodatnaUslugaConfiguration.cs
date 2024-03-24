using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class RezervacijaDodatnaUslugaConfiguration:BaseConfiguration<RezervacijaDodatnaUsluga>
    {
        public override void Configure(EntityTypeBuilder<RezervacijaDodatnaUsluga> builder)
        {
            base.Configure(builder);
            builder.HasKey(rd => new { rd.RezervacijaId, rd.DodatnaUslugaId });
            builder.HasOne(rd => rd.Rezervacija)
                   .WithMany(r => r.DodatneUsluge)
                   .HasForeignKey(rd => rd.RezervacijaId);
            builder.HasOne(rd => rd.DodatnaUsluga)
                   .WithMany(du => du.Rezervacije)
                   .HasForeignKey(rd => rd.DodatnaUslugaId);
        }
    }
}
