using Config.Net;
using myADMonitor.Models;
using System.Collections.Generic;
using System.DirectoryServices;
using System.DirectoryServices.ActiveDirectory;

namespace myADMonitor.Helpers
{
    public static class DirectoryState
    {
        private const StringComparison INSENSITIVE = StringComparison.CurrentCultureIgnoreCase;
        private static string DomainNameFQDN;
        private static DomainController connectedDC;
        private static Metaverse _metaverse;
        private static bool status_dBInitialized;
        private static string? LDAPConnectionString;
        private static long highestUSN;
        private static long startingUSN;
        private static long movingUSNLower;
        private static long movingUSNUpper;
        private static long stepUSN;
        private static HeaderData HeaderDataInfo;
        public static long TotalDeltas;
        private static bool status_IsDeltaRunning;
        private static string configFilePath;
        public static CustomConfig runConfig;
        public static bool listenAllIPs;
        public static int tCPPort;

        public static void Start()
        {
#if (DEBUG)
            configFilePath = @"C:\gitpublic\backend\myADMonitor\config.ini";
#elif (RELEASE)
            configFilePath = System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory + @"config.ini");
            //Console.WriteLine("SETTING\t Config file path:\t" + configFilePath);
            //Console.WriteLine(File.Exists(configFilePath) ? "File exists." : "File does not exist.");
#endif
            status_dBInitialized = false;
            status_IsDeltaRunning = false;
            _metaverse = new Metaverse();
            highestUSN = 0;
            startingUSN = 0;
            movingUSNLower = 0;
            movingUSNUpper = 999;
            stepUSN = 1000;
            HeaderDataInfo = new("", "", "", 0, 0, 0, 0, 0, 0, 0, 0, 0);
            TotalDeltas = 0;

            listenAllIPs = false;
            tCPPort = 5000;

            Console.WriteLine("SETTING\t Config file path:\t" + configFilePath);
            
            runConfig = new ConfigurationBuilder<CustomConfig>()
                .UseIniFile(configFilePath) //TODO: Stop if config file is not found
                .Build();
        }

        public static void Initialize()
        {
            // Set listening options
            if (!String.IsNullOrWhiteSpace(DirectoryState.runConfig.ListenAllIPs) && DirectoryState.runConfig.ListenAllIPs == "1")
                listenAllIPs = true;
            if (!String.IsNullOrWhiteSpace(DirectoryState.runConfig.TCPPort))
            {

                var parseSuccess = int.TryParse(DirectoryState.runConfig.TCPPort, out tCPPort);
                if (!parseSuccess)
                {
                    Console.WriteLine("Error parsing TCPPort number on config.ini file.");
                    System.Environment.Exit(1);

                }
                if (tCPPort <= 0 || tCPPort >= 65535)
                {
                    Console.WriteLine("Please use a port on config.ini file between 1 and 65535. Ideally in the range 1024<>65534.");
                    System.Environment.Exit(1);
                }

            }


            


            // Find current computer domain or fail
            try
            {
                DomainNameFQDN = Domain.GetComputerDomain().Name;
            }
            catch
            {
                Console.WriteLine("Error getting domain name from this computer. Closing...");
                System.Environment.Exit(1);
            }

            // Find reachable Domain Controller in the same site or use the config
            if (!String.IsNullOrWhiteSpace(runConfig.DomainControllerFQDN))
            {
                connectedDC = ConnectDomainController(runConfig.DomainControllerFQDN);
            }
            else
            {
                connectedDC = ConnectDomainController();
            }

            // Retrieve AD Schema syntaxes
            Console.WriteLine("INFO\tEnumerating AD attributes and their syntaxes");
            Console.WriteLine("INFO\tSchema syntaxes start:\t" + DateTime.Now);
            LDAPUtil.InitAttributeSyntaxTable();
            Console.WriteLine("INFO\tSchema syntaxes completed:\t" + DateTime.Now);

            // Build an LDAP connection string including Domain Controller and Domain
            // LDAP://testdc.domain01.local/DC=DOMAIN01,DC=LOCAL
            LDAPConnectionString = CreateLDAPConnectionString(connectedDC.Name, DomainNameFQDN);

            // Starting new sync strategy. Raw USN combing is slow in some environments
            #region NEW SYNC EXECUTION
            Console.WriteLine("INFO\tFinding highest USN...");
            Console.WriteLine("INFO\tExcluding query pages without objects.. Please wait.");
            List<long> usns = new List<long>();
            int counter = 0;
            SearchResultCollection tempFoundObjects = LDAPUtil.LDAPSearchCollection("(objectClass=*)", LDAPConnectionString);
            foreach (SearchResult item in tempFoundObjects)
            {
                try
                {
                    usns.Add((long)item.Properties["usnchanged"][0]);
                }
                catch
                {

                }
                

            }
            usns.Sort();
            Console.WriteLine("INFO\t{0} Total USNs found", usns.Count);

            long currentObjectUSN = 0;
            List<int> ranges = new List<int>();
            int currentRange = 0; // 0 to 999
            //List<long> usns2 = new List<long>() { 5, 10, 1000, 1001, 1999, 2000, 2001, 2007 };
            foreach (long usnValue in usns)
            {
                int startRange = currentRange * 1000;
                int endRange = startRange + 999; //TODO change magic number
                while (!(usnValue >= startRange && usnValue <= endRange))
                {
                    currentRange++;
                    startRange = currentRange * 1000;
                    endRange = startRange + 999; //TODO change magic number
                }
                if(usnValue >= startRange && usnValue <= endRange)
                {
                    //Console.WriteLine("value: {0} is in the range {1} {2}",usnValue,startRange, endRange);
                    ranges.Add(currentRange);
                }
            }

            ranges = ranges.Distinct().ToList();
            ranges.Sort();
            Console.WriteLine("INFO\t{0} Total pages with objects found. Starting building cache", ranges.Count);

            //Console.WriteLine(ranges);

            // Query all ranges
            // save startingTopUSN
            Console.WriteLine("INFO\tNEW SYNC start:\t" + DateTime.Now);
            
            highestUSN = connectedDC.HighestCommittedUsn;
            startingUSN = connectedDC.HighestCommittedUsn;
            foreach (int range in ranges)
            {
                movingUSNLower = range * 1000;
                movingUSNUpper = movingUSNLower + 999;
                string query = LDAPUtil.LDAPQueryRangeGenerator(movingUSNLower, movingUSNUpper);
                SearchResultCollection foundObjects = LDAPUtil.LDAPSearchCollection(query, LDAPConnectionString);
                try
                {
                    foreach (SearchResult searchResult in foundObjects) _metaverse.AddObjectAndChanges(searchResult);
                }
                catch (Exception ex)
                {
                    if (ex is ArgumentException)
                    {
                        Console.WriteLine("{0}. Closing...", ex.Message);
                        System.Environment.Exit(1);
                    }
                    throw;
                }
                int foundObjectsCount = foundObjects.Count;
                highestUSN = connectedDC.HighestCommittedUsn;
                Console.WriteLine("INFO\tRange {0} < {1}\t\tFound {2} objects in this range", movingUSNLower, movingUSNUpper, foundObjectsCount);

            }
            #endregion NEW SYNC EXECUTION

            #region OLD SYNC FOR REFERENCE
            //Below is the old strategy
            //Console.WriteLine("NEW SYNC start: " + DateTime.Now);
            //highestUSN = connectedDC.HighestCommittedUsn;
            //startingUSN = connectedDC.HighestCommittedUsn;
            //do
            //{
            //    //Console.WriteLine("Querying range {0} to {1}", movingUSNLower, movingUSNUpper);
            //    string query = LDAPUtil.LDAPQueryRangeGenerator(movingUSNLower, movingUSNUpper);
            //    SearchResultCollection foundObjects = LDAPUtil.LDAPSearchCollection(query, LDAPConnectionString);
            //    try
            //    {
            //        foreach (SearchResult searchResult in foundObjects) _metaverse.AddObjectAndChanges(searchResult);
            //    }
            //    catch (Exception ex)
            //    {
            //        if (ex is ArgumentException)
            //        {
            //            Console.WriteLine("{0}. Closing...", ex.Message);
            //            System.Environment.Exit(1);
            //        }
            //        throw;
            //    }

            //    int foundObjectsCount = foundObjects.Count;
            //    movingUSNLower += stepUSN;
            //    movingUSNUpper += stepUSN;
            //    highestUSN = connectedDC.HighestCommittedUsn;
            //    Console.WriteLine("comparing {0} < {1}. Found {2}", movingUSNLower, highestUSN, foundObjectsCount);
            //} while (movingUSNLower <= highestUSN);

            //if (startingUSN < highestUSN)
            //{
            //    Console.WriteLine("Highest USN changed during initial sync from {0} to {1}. Not a problem last range was {2} to {3}",
            //        startingUSN,
            //        highestUSN,
            //        movingUSNLower - stepUSN,
            //        movingUSNUpper - stepUSN);
            //}
            //else
            //{
            //    Console.WriteLine("Highest did NOT increase: from {0} to {1}. Not a problem last range was {2} to {3}",
            //       startingUSN,
            //       highestUSN,
            //       movingUSNLower - stepUSN,
            //       movingUSNUpper - stepUSN);
            //} 
            #endregion

            status_dBInitialized = true;



            Console.WriteLine("INFO\tNEW SYNC Complete:\t" + DateTime.Now);
            

            HeaderDataInfo.DomainName = DomainNameFQDN;
            HeaderDataInfo.DomainControllerFQDN = connectedDC.Name;
            HeaderDataInfo.Query = String.IsNullOrWhiteSpace(runConfig.LDAPQuery)
                ? "No custom LDAP. Include ALL objects"
                : HeaderDataInfo.Query = runConfig.LDAPQuery;
            UpdateHeaderDataInfo();
        } // End initialize

        public static void UpdateHeaderDataInfo()
        {
            HeaderDataInfo.TrackedUsers = _metaverse.CountUsers();
            HeaderDataInfo.TrackedGroups = _metaverse.CountGroups();
            HeaderDataInfo.TrackedContacts = _metaverse.CountContacts();
            HeaderDataInfo.TrackedComputers = _metaverse.CountComputers();
            HeaderDataInfo.TrackedOUs = _metaverse.CountOUs();
            HeaderDataInfo.TrackedOther = _metaverse.CountOthers();
            HeaderDataInfo.LatestUSNDetected = highestUSN;
            HeaderDataInfo.ChangesDetected = _metaverse.Changes.Count();
            HeaderDataInfo.ObjectsInDatabase = _metaverse.AllObjects.Count();
        }

        public static void FetchDeltaChanges()
        {
            // Query new highest USN and compared with the old highest USN
            // if new highest usn is greater than old highest usn
            //    Set a query from old highest USN + 1 >>>>>>>>> new highest USN

            long oldHighestUSN = highestUSN;
            long nextUSN = oldHighestUSN + 1;
            highestUSN = connectedDC.HighestCommittedUsn;

            // Do we have new changes?
            if (highestUSN > oldHighestUSN)
            {
                Console.WriteLine("INFO\tFetching changes from USN range: {0} <-> {1}", nextUSN, highestUSN);
                string query = LDAPUtil.LDAPQueryRangeGenerator(nextUSN, highestUSN);
                SearchResultCollection foundObjects = LDAPUtil.LDAPSearchCollection(query, LDAPConnectionString);
                foreach (SearchResult searchResult in foundObjects) _metaverse.AddObjectAndChanges(searchResult);
                Console.WriteLine("INFO\t{0} changed objects or new found", foundObjects.Count);
            }
            else { Console.WriteLine("INFO\t0 Changes detected"); }
        }

        private static DomainController ConnectDomainController(string optionalDomainControllerFQDN = "")
        {
            var computerDomain = Domain.GetComputerDomain();
            var domainControllers = computerDomain.DomainControllers;
            // If config file contains a DC, use it...
            if (!String.IsNullOrWhiteSpace(optionalDomainControllerFQDN))
            {
                foreach (DomainController dc in domainControllers)
                {
                    if (dc.Name.Equals(optionalDomainControllerFQDN, INSENSITIVE)) { return dc; }
                }
                Console.WriteLine("Error finding {0} Domain Controller on enumerated DCs list. Please check the name. Closing...", optionalDomainControllerFQDN);
                System.Environment.Exit(1);
            }
            // ...otherwise try to find a reachable DC in the same site
            ActiveDirectorySite currentADSite = ActiveDirectorySite.GetComputerSite(); //currentADSite.Servers has the local DCs
            var currentSiteServers = currentADSite.Servers;
            foreach (DomainController dc in currentSiteServers)
            {
                try
                {
                    Console.WriteLine("SETTING\t Domain Controller FQDN:\t" + dc.Name);
                    Console.WriteLine("SETTING\t AD Site:\t" + dc.SiteName);
                    return dc;
                }
                catch (Exception)
                {
                    continue;
                }
            }

            Console.WriteLine("Tried to find a suitable DC in the same site, but they seem unreachable. Use config file to specify a DC.. Closing...");
            System.Environment.Exit(1);
            throw new Exception(""); //TODO: Otherwise compiler complains not all code paths return a value. Exit is part of the framework, compiler not aware
        }

        private static string CreateLDAPConnectionString(string FQDN, string domainNameFQDN)
        {
            string LDAPConnectionString = "LDAP://" + FQDN + "/";
            string[] domainFQDNSplit = domainNameFQDN.Split('.');
            foreach (string part in domainFQDNSplit) LDAPConnectionString += "DC=" + part + ",";
            return LDAPConnectionString.Remove(LDAPConnectionString.Length - 1);
        }

        public static int CountRetrievedObjects()
        {
            return _metaverse.CountCacheObjects();
        }

        public static Guid[] RetrieveListGuidObjects()
        {
            return _metaverse.ListGuidObjects();
        }

        public static string[] RetrieveListAllsAMAccountName()
        {
            return _metaverse.ListAllsAMAccountName();
        }

        public static UserDTO[] RetrieveListAllUsers()
        {
            return _metaverse.ListAllUsers();
        }

        public static string[] RetrieveListAllChanges()
        {
            return _metaverse.ListAllChanges();
        }

        public static Change[] RetrieveListAllChanges2()
        {
            return _metaverse.ListAllChanges2();
        }

        public static GuidChangesAggregated[] RetrieveListAllChanges3()
        {
            return _metaverse.ListAllChanges3();
        }

        public static long GetCurrentUSN()
        {
            return highestUSN;
        }

        public static bool GetDBInitialized()
        {
            return status_dBInitialized;
        }

        public static string GetDomainNameFQDN()
        {
            return DomainNameFQDN;
        }

        public static bool GetDeltaRunning()
        {
            return status_IsDeltaRunning;
        }

        public static void SetDeltaRunningTrue()
        {
            status_IsDeltaRunning = true;
        }

        public static void SetDeltaRunningFalse()
        {
            status_IsDeltaRunning = false;
        }

        public static HeaderData RetrieveHeaderData()
        {
            return HeaderDataInfo;
        }
    }
}