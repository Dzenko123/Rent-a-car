using Microsoft.AspNetCore.Mvc;
using RentACar.Model.Models;
using RentACar.Services.IServices;

namespace RentACar.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ToDo4924Controller : BaseCRUDController<ToDo4924, Model.SearchObject.ToDo4924SearchObject, Model.Requests.ToDo4924InsertRequest, Model.Requests.ToDo4924UpdateRequest, Model.Requests.ToDo4924DeleteRequest>
    {
        public ToDo4924Controller(ILogger<BaseController<ToDo4924, Model.SearchObject.ToDo4924SearchObject>> logger, IToDo4924Service service) : base(logger, service)
        {
        }
    }
}
