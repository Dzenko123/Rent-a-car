﻿using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RentACar.Model.Requests;
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
    public class KorisniciService: IKorisniciService
    {
        RentACarDBContext _context;
        public IMapper _mapper { get; set; }
        public KorisniciService(RentACarDBContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<Model.Korisnici>> Get()
        {
            var entityList = await _context.Korisnicis.ToListAsync();

            return _mapper.Map<List<Model.Korisnici>>(entityList);
        }

        public Model.Korisnici Insert(KorisniciInsertRequest request)
        {
            var entity=new Korisnici();
            _mapper.Map(request, entity);

            entity.LozinkaSalt=GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Password);

            _context.Korisnicis.Add(entity);
            _context.SaveChanges();

            return _mapper.Map<Model.Korisnici>(entity);
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

        public Model.Korisnici Update(int id, KorisniciUpdateRequest request)
        {
            var entity = _context.Korisnicis.Find(id);
            _mapper.Map(request, entity);
            _context.SaveChanges();
            return _mapper.Map<Model.Korisnici>(entity);
        }
    }
}