﻿using Microsoft.AspNetCore.Mvc;
using RentACar.Model;
using RentACar.Services;

namespace RentACar.Controllers
{
    [Route("[controller]")]

    public class BaseController<T, TSearch> : ControllerBase where T: class where TSearch : class
    {
        private readonly IService<T, TSearch> _service;
        private readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch>> logger, IService<T, TSearch> service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet]
        public async Task<PagedResult<T>> Get([FromQuery]TSearch? search=null)
        {
            return await _service.Get(search);
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
}