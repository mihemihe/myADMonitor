using Microsoft.AspNetCore.Mvc;
using myADMonitor.Helpers;
using myADMonitor.Models;
using System.Security.Claims;

namespace myADMonitor.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class adupdatesController : ControllerBase
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

        // 2. Get Changes by Object Class

        //GET /by-class
        //Query parameter: objectClass(can be multiple, comma-separated)
        //Returns changes for objects of the specified class(es).
        //Example: /api/v1/ad-updates/by-class?objectClass=user,computer,organizationalUnit
        [HttpGet("by-class")]
        public ActionResult<GuidChangesAggregated[]> GetChangesByObjectClass([FromQuery] string objectclass)
        {
            // Call a method to retrieve changes for objects of the specified class(es)
            
            return DirectoryState.RetrieveListAllChangesByObjectClass(objectclass);

            
        }




    }
}