using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Models;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace RentACar.Services
{
    public class KorisniciService: BaseCRUDService<Model.Models.Korisnici, Database.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest, KorisniciDeleteRequest>, IKorisniciService
    {
        public KorisniciService(RentACarDBContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Database.Korisnici entity, KorisniciInsertRequest insert)
        {
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
        }
  

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src=Convert.FromBase64String(salt);
            byte[] bytes=Encoding.Unicode.GetBytes(password);
            byte[] dst=new byte[src.Length+bytes.Length];
            
            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes,0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);

        }

        //public Model.Korisnici Update(int id, KorisniciUpdateRequest request)
        //{
        //    var entity = _context.Korisnicis.Find(id);
        //    _mapper.Map(request, entity);
        //    _context.SaveChanges();
        //    return _mapper.Map<Model.Korisnici>(entity);
        //}

        public override IQueryable<Database.Korisnici> AddInclude(IQueryable<Database.Korisnici> query, KorisniciSearchObject? search = null)
        {
            if(search?.IsUlogeIncluded==true)
            {
                query = query.Include("KorisniciUloge.Uloga");
            }
            return base.AddInclude(query, search);
        }

        public async Task<Model.Models.Korisnici> Login(string username, string password)
        {
            var entity = await _context.Korisnicis.Include("KorisniciUloge.Uloga").FirstOrDefaultAsync(x=>x.KorisnickoIme==username);

            if(entity==null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);
            if(hash!=entity.LozinkaHash)
            {
                return null;
            }
            return _mapper.Map<Model.Models.Korisnici>(entity);
        }
    }
}
