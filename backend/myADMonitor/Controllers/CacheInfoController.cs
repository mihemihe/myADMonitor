using Microsoft.AspNetCore.Mvc;
using myADMonitor.Helpers;
using myADMonitor.Models;

namespace myADMonitor.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CacheInfoController : ControllerBase
    {
        [HttpGet("cachecounter")]
        public ActionResult<int> GetCacheCounter()
        {
            return DirectoryState.CountRetrievedObjects();
        }

        [HttpGet("guidlist")]
        public ActionResult<Guid[]> GetGuidList()
        {
            return DirectoryState.RetrieveListGuidObjects();
        }

        [HttpGet("samlist")]
        public ActionResult<string[]> GetSamList()
        {
            return DirectoryState.RetrieveListAllsAMAccountName();
        }

        [HttpGet("recentchanges")]
        public ActionResult<string[]> GetRecentChangesList()
        {
            return DirectoryState.RetrieveListAllChanges();
        }

        [HttpGet("recentchanges2")]
        public ActionResult<Change[]> GetRecentChangesList2()
        {
            return DirectoryState.RetrieveListAllChanges2().ToArray();
        }

        [HttpGet("recentchanges3")]
        public ActionResult<GuidChangesAggregated[]> GetRecentChangesList3()
        {
            return DirectoryState.RetrieveListAllChanges3().ToArray();
        }

        [HttpGet("userlist")]
        public ActionResult<UserDTO[]> GetUserList()
        {
            return DirectoryState.RetrieveListAllUsers();
        }

        [HttpGet("headerdata")]
        public ActionResult<HeaderData> GetHeaderData()
        {
            return DirectoryState.RetrieveHeaderData();
        }
    }
}