using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class KontaktConfiguration:BaseConfiguration<Kontakt>
    {
        public override void Configure(EntityTypeBuilder<Kontakt> builder)
        {
            base.Configure(builder);
            builder.HasKey(x => x.KontaktId);

            builder.HasOne(k => k.Korisnik)
                   .WithMany()
                   .HasForeignKey(k => k.KorisnikId)
                   .OnDelete(DeleteBehavior.Cascade); ;
        }
    }
}
