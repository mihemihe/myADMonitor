using Microsoft.AspNetCore.Mvc;

//using ActiveDs; dotnet publish fails to build because COM, even with windows target

namespace myADMonitor.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChangedObjectsController : ControllerBase
    {
        [HttpGet]
        public ActionResult<int> Get()
        {
            return Ok(47);
        }
    }
}