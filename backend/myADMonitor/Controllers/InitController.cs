using Microsoft.AspNetCore.Mvc;

namespace myADMonitor.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InitController : ControllerBase
    {
        [HttpGet]
        public ActionResult<bool> Get()
        {
            return Ok(false);
        }
    }
}