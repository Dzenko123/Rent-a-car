﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Database
{
    [Table("TipVozila")]
    public class TipVozila
    {
        [Key]
        public int Id { get; set; }

        public string Tip { get; set; } = null!;

        public string Marka { get; set; } = null!;

        public string Model { get; set; } = null!;
    }
}