﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("Kontakt")]
    public class Kontakt
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("Korisnici")]
        public int KorisnikId { get; set; }

        public Korisnici Korisnik { get; set; } = null!;

        public string Poruka { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string Email { get; set; } = null!;
    }
}