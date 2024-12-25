using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class ToDo4924Configuration : BaseConfiguration<ToDo4924>
    {
        public override void Configure(EntityTypeBuilder<ToDo4924> builder)
        {
            base.Configure(builder);
            builder.HasKey(x => x.ToDo4924Id);

            builder.HasOne(k => k.Korisnik)
                   .WithMany()
                   .HasForeignKey(k => k.KorisnikId);
        }
    }
}
