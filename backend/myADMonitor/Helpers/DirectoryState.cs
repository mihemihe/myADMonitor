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
        private static string? DomainNameFQDN;
        private static DomainController? connectedDC;
        private static readonly Metaverse _metaverse = new();
        private static bool status_dBInitialized;
        private static string? LDAPConnectionString;
        private static long highestUSN;
        private static long movingUSNLower;
        private static long movingUSNUpper;
        private static readonly HeaderData HeaderDataInfo = new();
        public static long TotalDeltas;
        private static bool status_IsDeltaRunning;
        private static string? configFilePath;
        public static ICustomConfig? runConfig;
        public static bool listenAllIPs;
        public static int tCPPort;

        public static void Start()
        {
#if (DEBUG)
            configFilePath = @"C:\gitpublic\backend\myADMonitor\config.ini";
#elif (RELEASE)
            configFilePath = System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory + @"config.ini");

#endif
            status_dBInitialized = false;
            status_IsDeltaRunning = false;
            highestUSN = 0;
            movingUSNLower = 0;
            movingUSNUpper = 999;
            TotalDeltas = 0;

            listenAllIPs = false;
            tCPPort = 5000;

            Console.WriteLine("SETTING\t Config file path:\t" + configFilePath);

            // check if configFilePath file is found
            if (!System.IO.File.Exists(configFilePath))
            {
                Console.WriteLine("ERROR\t" + configFilePath + " configuration file not found. Starting myADMonitor with default settings.");
                Console.WriteLine("ERROR\t" + "Default settings not implemented yet, exiting....");
                System.Environment.Exit(1);
            }
            else
            {
                runConfig = new ConfigurationBuilder<ICustomConfig>()
                    .UseIniFile(configFilePath) //TODO: Stop if config file is not found
                    .Build();
                //Console.WriteLine(runConfig);
            }
            //TODO: Set all config settings here, right after reading the config file.
        }

        public static void Initialize()
        {
            // Set listening options.
            // If setting from file is set and it is 1, set listening to 0.0.0.0. Else listenAllIPs = false (default)            
            if (!String.IsNullOrWhiteSpace(DirectoryState.runConfig?.ListenAllIPs) && DirectoryState.runConfig.ListenAllIPs == "1")
                listenAllIPs = true;

            // Try parse the custom port if defined. Otherwise default will be used, 5000 TCP
            if (!String.IsNullOrWhiteSpace(DirectoryState.runConfig?.TCPPort))
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
            //TODO: Find a domain controller in the next site if the current site has no DCs. Warn the user about it and request confirmation.
            if (!String.IsNullOrWhiteSpace(runConfig?.DomainControllerFQDN))
            {
                connectedDC = ConnectDomainController(runConfig.DomainControllerFQDN);
            }
            else
            {
                connectedDC = ConnectDomainController();
            }

            // Retrieve AD Schema syntaxes
            Console.WriteLine("INFO\tEnumerating AD attributes and their syntaxes");
            Console.WriteLine("INFO\tSchema syntaxes start:\t\t" + DateTime.Now);
            LDAPUtil.InitAttributeSyntaxTable();
            Console.WriteLine("INFO\tSchema syntaxes completed:\t" + DateTime.Now);

            // Build an LDAP connection string including Domain Controller and Domain
            // LDAP://testdc.domain01.local/DC=DOMAIN01,DC=LOCAL
            LDAPConnectionString = CreateLDAPConnectionString(connectedDC.Name, DomainNameFQDN);

            // Starting new sync strategy. Raw USN combing is slow in some environments
            #region NEW SYNC EXECUTION
            var stopwatch = new System.Diagnostics.Stopwatch();
            stopwatch.Start();

            Console.WriteLine("INFO\tFinding highest USN...");
            Console.WriteLine("INFO\tExcluding query pages without objects.. Please wait.");
            List<long> usns = new List<long>();
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

            // The algorithm below is a bit inneficient, but it´s just integer arithmetic. O(n) complexity.
            Console.WriteLine("INFO\t{0} Total USNs found", usns.Count);
            List<int> ranges = ExtractPopulatedRanges(usns);
            Console.WriteLine("INFO\t{0} Total pages with objects found. Starting building cache", ranges.Count);
            stopwatch.Stop();
            Console.WriteLine("INFO\tUSN extraction and range calculation took: {0} seconds", stopwatch.ElapsedMilliseconds / 1000);
            stopwatch.Reset();
            stopwatch.Start();
            Console.WriteLine("INFO\tNEW SYNC start:\t" + DateTime.Now);

            var outterStopWatch = new System.Diagnostics.Stopwatch();
            outterStopWatch.Start();
            int totalObjecsFound = 0;


            highestUSN = connectedDC.HighestCommittedUsn;
            foreach (int range in ranges)
            {
                var innerStopWatch = new System.Diagnostics.Stopwatch();
                innerStopWatch.Start();
                movingUSNLower = range * 1000;
                movingUSNUpper = movingUSNLower + 999;
                string query = LDAPUtil.LDAPQueryRangeGenerator(movingUSNLower, movingUSNUpper);
                SearchResultCollection foundObjects = LDAPUtil.LDAPSearchCollection(query, LDAPConnectionString);
                try
                {
                    foreach (SearchResult searchResult in foundObjects) _metaverse.AddOrUpdateObject(searchResult);
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
                totalObjecsFound += foundObjectsCount;


                highestUSN = connectedDC.HighestCommittedUsn;
                innerStopWatch.Stop();
                double rate;
                int intRate;
                if (innerStopWatch.ElapsedMilliseconds > 0)
                {
                    rate = (double)foundObjectsCount * (1000f / innerStopWatch.ElapsedMilliseconds);
                    intRate = (int)rate;
                }
                else
                {
                    intRate = 0;
                }

                double totalRate;
                int totalIntRate;

                if (outterStopWatch.ElapsedMilliseconds > 0)
                {
                    totalRate = (double)(totalObjecsFound * 1000) / outterStopWatch.ElapsedMilliseconds;
                    totalIntRate = (int)totalRate;

                }
                else
                {
                    totalIntRate = 0;
                }

                int remainingObjects = usns.Count - totalObjecsFound;

                int ETA = 0;

                if (totalIntRate == 0)
                { ETA = 0;}
                else
                { ETA = remainingObjects / totalIntRate;}

                Console.WriteLine("Range {0} <> {1}\t\tFound {2}\t (Avg. rate {3} obj/s. Left {4}. ETA: {5} seconds)",
                    movingUSNLower, movingUSNUpper, foundObjectsCount, totalIntRate, remainingObjects, ETA);

            }
            outterStopWatch.Stop();
            status_dBInitialized = true;

            Console.WriteLine("INFO\tNEW SYNC Complete:\t" + DateTime.Now);
            stopwatch.Stop();
            Console.WriteLine("INFO\tNEW SYNC took: {0} seconds", stopwatch.ElapsedMilliseconds / 1000);

            #endregion NEW SYNC EXECUTION

            HeaderDataInfo.DomainName = DomainNameFQDN;
            HeaderDataInfo.DomainControllerFQDN = connectedDC.Name;
            HeaderDataInfo.Query = string.IsNullOrEmpty(runConfig?.LDAPQuery) ? "No custom LDAP. Include ALL objects" : runConfig.LDAPQuery;

            UpdateHeaderDataInfo();
        } // End initialize

        private static List<int> ExtractPopulatedRanges(List<long> usns)
        {
            List<int> ranges = new List<int>();
            int currentRangeMultiplier = 0;
            foreach (long usnValue in usns)
            {
                int startRange = currentRangeMultiplier * 1000;
                int endRange = startRange + 999; //TODO change magic number
                // USN do not start at 0, but probably around 5000. This skips the first ranges without objects
                while (!(usnValue >= startRange && usnValue <= endRange))
                {
                    currentRangeMultiplier++;
                    startRange = currentRangeMultiplier * 1000;
                    endRange = startRange + 999; //TODO change magic number
                }
                if (usnValue >= startRange && usnValue <= endRange)
                {
                    //Console.WriteLine("value: {0} is in the range {1} {2}",usnValue,startRange, endRange);
                    ranges.Add(currentRangeMultiplier);
                }
            }

            ranges = ranges.Distinct().ToList();
            ranges.Sort();
            return ranges;
        }

        public static void UpdateHeaderDataInfo()
        {
            HeaderDataInfo.TrackedUsers = _metaverse.CountUsers();
            HeaderDataInfo.TrackedGroups = _metaverse.CountGroups();
            HeaderDataInfo.TrackedContacts = _metaverse.CountContacts();
            HeaderDataInfo.TrackedComputers = _metaverse.CountComputers();
            HeaderDataInfo.TrackedOUs = _metaverse.CountOUs();
            HeaderDataInfo.TrackedOther = _metaverse.CountOthers();
            HeaderDataInfo.LatestUSNDetected = highestUSN;
            HeaderDataInfo.ChangesDetected = _metaverse.Changes.Count;
            HeaderDataInfo.ObjectsInDatabase = _metaverse.AllObjects.Count;
        }

        public static void FetchDeltaChanges()
        {
            // Query new highest USN and compared with the old highest USN
            // if new highest usn is greater than old highest usn
            //    Set a query from old highest USN + 1 >>>>>>>>> new highest USN

            long oldHighestUSN = highestUSN;
            long nextUSN = oldHighestUSN + 1;
            highestUSN = connectedDC!.HighestCommittedUsn;

            // Do we have new changes?
            if (highestUSN > oldHighestUSN)
            {
                Console.WriteLine("INFO\tFetching changes from USN range: {0} <-> {1}", nextUSN, highestUSN);
                string query = LDAPUtil.LDAPQueryRangeGenerator(nextUSN, highestUSN);
                SearchResultCollection foundObjects = LDAPUtil.LDAPSearchCollection(query, LDAPConnectionString!);
                foreach (SearchResult searchResult in foundObjects) _metaverse.AddOrUpdateObject(searchResult);
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
                    //TODO: this is too clever, if it is not reachable it will catch an exception and continue to the next one
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
            return DomainNameFQDN!;
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

        public static GuidChangesAggregated[] RetrieveListAllChangesByObjectClass(string objectClasses)
        {
            return _metaverse.ListAllChangesByObjectClass(objectClasses);
        }

        public static GuidChangesAggregated[] RetrieveListChangesApplyAllFilters(string objectClasses, string objectNameFilter, string attributeFilter, string showOnlyFilteredAttribute)
        {
            return _metaverse.ListChangesApplyAllFilters(objectClasses, objectNameFilter, attributeFilter, showOnlyFilteredAttribute);
        }
    }
}

//TODO: explore the tombstone on DirectorySearcher to track deleted objects
//TODO: explore AttributeScopeQuery  to search by members for groups
//TODO: Add identification of other classes, such as the ones when you add a RODC
//TODO: Handle updating an attribute with the same value. It is a change, but it show some feedback to the user
//TODO: Slack integration, optionally SMTP integration