namespace myADMonitor.Models
{
    public class HeaderData
    {
        public string DomainName { get; set; }
        public string DomainControllerFQDN { get; set; }
        public string Query { get; set; }
        public int ObjectsInDatabase { get; set; }
        public int ChangesDetected { get; set; }
        public long LatestUSNDetected { get; set; }
        public int TrackedUsers { get; set; }
        public int TrackedComputers { get; set; }
        public int TrackedContacts { get; set; }
        public int TrackedOUs { get; set; }
        public int TrackedGroups { get; set; }
        public int TrackedOther { get; set; }

        public HeaderData(string domainName,
            string domainControllerFQDN,
            string query,
            int objectsInDatabase,
            int changesDetected,
            long latestUSNDetected,
            int trackedUsers,
            int trackedComputers,
            int trackedContacts,
            int trackedOUs,
            int trackedGroups,
            int trackedOther)
        {
            DomainName = domainName;
            DomainControllerFQDN = domainControllerFQDN;
            Query = query;
            ObjectsInDatabase = objectsInDatabase;
            ChangesDetected = changesDetected;
            LatestUSNDetected = latestUSNDetected;
            TrackedUsers = trackedUsers;
            TrackedComputers = trackedComputers;
            TrackedContacts = trackedContacts;
            TrackedOUs = trackedOUs;
            TrackedGroups = trackedGroups;
            TrackedOther = trackedOther;
        }
    }
}