﻿using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Configurations
{
    public class RezervacijaConfiguration:BaseConfiguration<Rezervacija>
    {
        public override void Configure(EntityTypeBuilder<Rezervacija> builder)
        {
            base.Configure(builder);
            builder.HasKey(r => r.RezervacijaId);
            builder.HasOne(r => r.Korisnik)
                   .WithMany()
                   .HasForeignKey(r => r.KorisnikId);
            builder.HasOne(r => r.Vozilo)
                   .WithMany()
                   .HasForeignKey(r => r.VoziloId)
                   .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(r => r.Racun)
                   .WithMany()
                   .HasForeignKey(r => r.RacunId);
            builder.HasOne(r => r.Lokacija)
                   .WithMany()
                   .HasForeignKey(r => r.LokacijaId);
        }
    }
}