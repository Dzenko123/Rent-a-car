﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Model.SearchObject
{
    public class RezervacijaSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public bool? IsDodatneUslugeIncluded { get; set; }

    }
}