using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Requests;
using RentACar.Model.SearchObject;
using RentACar.Services.Database;
using RentACar.Services.IServices;
using System.Security.Cryptography;
using System.Text;

namespace RentACar.Services.Services
{
    public class KorisniciService : BaseCRUDService<Model.Models.Korisnici, Database.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest, KorisniciDeleteRequest>, IKorisniciService
    {
        public KorisniciService(RentACarDBContext context, IMapper mapper)
            : base(context, mapper)
        {
        }
        public override IQueryable<Database.Korisnici> AddFilter(IQueryable<Database.Korisnici> query, KorisniciSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FirstName) || !string.IsNullOrWhiteSpace(search?.LastName))
            {
                var firstNamePattern = search?.FirstName ?? "";
                var lastNamePattern = search?.LastName ?? "";

                filteredQuery = filteredQuery.Where(x =>
                    (string.IsNullOrWhiteSpace(firstNamePattern) || EF.Functions.Like(x.Ime, $"%{firstNamePattern}%")) &&
                    (string.IsNullOrWhiteSpace(lastNamePattern) || EF.Functions.Like(x.Prezime, $"%{lastNamePattern}%"))
                );
            }

            return filteredQuery;
        }


        public override async Task BeforeInsert(Database.Korisnici entity, KorisniciInsertRequest insert)
        {
            var existingUser = await _context.Korisnicis.FirstOrDefaultAsync(k => k.KorisnickoIme == insert.KorisnickoIme);

            if (existingUser != null)
            {
                throw new Exception("Korisnik s istim korisničkim imenom već postoji.");
            }

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);

            var existingRole = await _context.Uloge.FirstOrDefaultAsync(u => u.Naziv == "user" && u.Opis == "user");

            if (existingRole != null)
            {
                entity.KorisniciUloge.Add(new KorisniciUloge { UlogaId = existingRole.UlogaId });
            }
            else
            {
                var novaUloga = new Uloge
                {
                    Naziv = "user",
                    Opis = "user"
                };

                entity.KorisniciUloge.Add(new KorisniciUloge { Uloga = novaUloga });
            }
        }

        public async Task<bool> VerifyOldPassword(int id, string oldPassword)
        {
            var entity = await _context.Korisnicis.FindAsync(id);

            if (entity == null)
            {
                throw new Exception("Korisnik nije pronađen");
            }

            var hash = GenerateHash(entity.LozinkaSalt, oldPassword);

            return hash == entity.LozinkaHash;
        }


        public async Task<int?> GetLoged(string username, string password)
        {
            var entity = await _context.Korisnicis.FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return entity.KorisnikId;
        }
        public async Task<(int? korisnikId, string uloga)> GetLogedWithRole(string username, string password)
        {
            var entity = await _context.Korisnicis
                .Include(x => x.KorisniciUloge)
                .ThenInclude(x => x.Uloga)
                .FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return (null, null);
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return (null, null);
            }

            var uloga = entity.KorisniciUloge.FirstOrDefault()?.Uloga.Naziv;

            return (entity.KorisnikId, uloga);
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
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);

        }

        public override IQueryable<Database.Korisnici> AddInclude(IQueryable<Database.Korisnici> query, KorisniciSearchObject? search = null)
        {
            if (search?.IsUlogeIncluded == true)
            {
                query = query.Include("KorisniciUloge.Uloga");
            }
            return base.AddInclude(query, search);
        }

        public async Task<Model.Models.Korisnici> Login(string username, string password)
        {
            var entity = await _context.Korisnicis.Include("KorisniciUloge.Uloga").FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);
            if (hash != entity.LozinkaHash)
            {
                return null;
            }
            return _mapper.Map<Model.Models.Korisnici>(entity);
        }
        public async Task UpdatePasswordAndUsername(int id, KorisniciUpdateRequestLimited request)
        {
            var entity = await _context.Korisnicis.FindAsync(id);

            if (entity == null)
            {
                throw new Exception("Korisnik nije pronađen");
            }

            entity.KorisnickoIme = request.KorisnickoIme;

            if (!string.IsNullOrWhiteSpace(request.Password))
            {
                entity.LozinkaSalt = GenerateSalt();
                entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Password);
            }

            _context.Update(entity);
            await _context.SaveChangesAsync();
        }
    }
}
