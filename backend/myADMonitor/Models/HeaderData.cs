namespace myADMonitor.Models
{
    public class HeaderData
    {
        public string DomainName { get; set; } = "";
        public string DomainControllerFQDN { get; set; } = "";
        public string Query { get; set; } = "";
        public int ObjectsInDatabase { get; set; }
        public int ChangesDetected { get; set; }
        public long LatestUSNDetected { get; set; }
        public int TrackedUsers { get; set; }
        public int TrackedComputers { get; set; }
        public int TrackedContacts { get; set; }
        public int TrackedOUs { get; set; }
        public int TrackedGroups { get; set; }
        public int TrackedOther { get; set; }
        public List<string> AttributesFiltered { get; set; } = new();

        public HeaderData()
        {
            // Default constructor
            // Integer properties are automatically initialized to 0
        }
    }
}