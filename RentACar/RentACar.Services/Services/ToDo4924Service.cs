using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services.Services
{
    public class ToDo4924Service : BaseCRUDService<Model.Models.ToDo4924, Database.ToDo4924, ToDo4924SearchObject, ToDo4924InsertRequest, ToDo4924UpdateRequest, ToDo4924DeleteRequest>, IToDo4924Service
    {

        public ToDo4924Service(RentACarDBContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<Database.ToDo4924> AddInclude(IQueryable<Database.ToDo4924> query, ToDo4924SearchObject? search = null)
        {
            query = query.Include(x => x.Korisnik);
            return base.AddInclude(query, search);
        }


        public override IQueryable<Database.ToDo4924> AddFilter(IQueryable<Database.ToDo4924> query, ToDo4924SearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search != null)
            {
                if (search.KorisnikId > 0)
                {
                    filteredQuery = filteredQuery.Where(x => x.KorisnikId == search.KorisnikId);
                }

                if (search.DatumPocetka.HasValue)
                {
                    filteredQuery = filteredQuery.Where(x => x.DatumIzvrsenja <= search.DatumPocetka.Value);
                }
            }

            return filteredQuery;
        }
    }
}
