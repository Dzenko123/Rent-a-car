using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RentACar.Model;
using RentACar.Services;

namespace RentACar.Controllers
{
    [Route("[controller]")]

    public class BaseCRUDController<T, TSearch, TInsert, TUpdate, TDelete> : BaseController<T, TSearch> where T: class where TSearch : class
    {
        protected new readonly ICRUDService<T, TSearch, TInsert, TUpdate, TDelete> _service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCRUDController(ILogger<BaseController<T, TSearch>> logger, ICRUDService<T, TSearch, TInsert, TUpdate, TDelete> service)
            :base(logger, service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        //[Authorize(Roles = "Administrator")]
        public virtual async Task<T> Insert([FromBody] TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody] TUpdate update)
        {
            return await _service.Update(id,update);
        }
        [HttpDelete("{id}")]
        public virtual async Task<T> Delete(int id, [FromBody] TDelete delete)
        {
            return await _service.Delete(id, delete);
        }


    }
}
