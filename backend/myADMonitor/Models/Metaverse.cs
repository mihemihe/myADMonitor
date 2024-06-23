using myADMonitor.Helpers;
using System.DirectoryServices;
using System.Globalization;

//test
namespace myADMonitor.Models
{
    public class Metaverse
    {
        public Dictionary<Guid, ADObject> AllObjects;
        public List<string> ModifiedObjects;
        public List<Change> Changes;
        private List<string> attributesToIgnore;
        private readonly object changesLock = new object();

        // MAF
        public static string changesLogFile;

        public static List<string> changesLogLines;
        public static string filesPath;

        public Metaverse()
        {
            Console.WriteLine("----------------------------- myADMonitor 0.5.004 ----------------------------");
            Console.WriteLine("Starting...");

            // Initialize collections
            AllObjects = new Dictionary<Guid, ADObject>();
            ModifiedObjects = new List<string>();
            Changes = new List<Change>();

            // Set attributes to ignore
            attributesToIgnore = new List<string>() { "msds-revealedusers" }; //TODO: Enhancement, test the solution work for this attribute for RDOC

            // Initialize logging 
            changesLogLines = new List<string>();
            filesPath = GetFilesRootPath();
            changesLogFile = filesPath + string.Format("ADCHANGES-{0:yyyy-MM-dd_hh-mm-ss-tt}.tsv", DateTime.Now);
            Console.WriteLine("SETTING\t Changes log file:\t" + changesLogFile);


        }

        private static string GetFilesRootPath()
        {
#if DEBUG
            return @"C:\Misc\myadmonitorlog\";

#elif RELEASE
            return System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory);
#endif
        }

        public void AddOrUpdateObject(SearchResult _searchResult)
        {
            lock (changesLock)
            {
                // -1- Compose basic object identification attributes and a friendly name
                bool specialCaseMember = false;
                bool specialCasemsds_revealedusers = false;
                Guid objectGuid = new Guid((byte[])_searchResult.Properties["objectGuid"][0]);
                string path = _searchResult.Path;
                string dn = (string)_searchResult.Properties["distinguishedName"][0];
                string friendlyName;
                if (_searchResult.Properties.Contains("cn"))
                {
                    friendlyName = (string)_searchResult.Properties["cn"][0];
                }
                else if (_searchResult.Properties.Contains("distinguishedName")) //TODO: Check the casing on Name, does this work?
                {
                    friendlyName = (string)_searchResult.Properties["distinguishedName"][0];//TODO: Check the casing on Name, does this work?
                }
                else
                {
                    Console.WriteLine("Neither CN nor DN" + path);
                    friendlyName = path;
                }
                ADObject forgeADObject = new ADObject(objectGuid, path, dn, friendlyName);
                Console.WriteLine("");
                Console.WriteLine(friendlyName);


                // -2- For each property in the object
                foreach (string propertyName in _searchResult.Properties.PropertyNames)
                {
                    Console.WriteLine(propertyName);
                    switch (propertyName)
                    {
                        case "useraccountcontrol":
                            //Console.WriteLine("useraccountcontrol");
                            // Create enum with all useraccountcontrol values
                            // decode as binary flag
                            List<string> UACFlagsActive = new List<string>();
                            int currentUAC = (int)_searchResult.Properties["useraccountControl"][0];

                            foreach (int flag in Enum.GetValues(typeof(UserAccountControl)))
                            {
                                int flagDetector = (currentUAC & flag);
                                //Console.WriteLine($" {flag}");
                                //Console.WriteLine("Result &: " + flagDetector.ToString());
                                if (flagDetector > 0)
                                {
                                    //Console.WriteLine(Enum.GetName(typeof(UserAccountControl), flagDetector));
                                    UACFlagsActive.Add(Enum.GetName(typeof(UserAccountControl), flagDetector));
                                }
                            }
                            forgeADObject.AddAttribute(propertyName, UACFlagsActive);
                            break;

                        case "usnchanged":

                            forgeADObject.USN = (long)_searchResult.Properties[propertyName][0];

                            //  Console.WriteLine(_forge.USN + "  <=> TOP USN: " + DirectoryState.GetCurrentUSN());

                            break;

                        case "objectclass":
                            forgeADObject.ObjectClass = LDAPUtil.GetClass(_searchResult.Properties[propertyName]);
                            break;

                        case "adspath":
                            break;

                        case "member;range=0-1499": //TODO: change this to something more generic, old AD maybe different
                            specialCaseMember = true;
                            Console.WriteLine("WARNING:\tLarge member attribute detected +1500 members." + propertyName);
                            var allValues = LDAPUtil.EnumerateLargeProperty(_searchResult.Properties["adspath"][0].ToString(), "member");
                            forgeADObject.AddAttribute("memberComplete", allValues);

                            // SPECIAL CASE GROUP +1500 members
                            // Generated a new ParsedAttributeValues for propery member
                            break;

                        case "msds-revealedusers;range=0-1499":
                            Console.WriteLine("strange case msds-revealedusers;range=0-1499");
                            specialCasemsds_revealedusers = true;
                            Console.WriteLine("WARNING:\tLarge msds-revealedusers attribute detected +1500 members." + propertyName);
                            var allValues2 = LDAPUtil.EnumerateLargeProperty(
                                _searchResult.Properties["adspath"][0].ToString(),
                                "msds-revealedusers");
                            forgeADObject.AddAttribute("msds-revealedusersComplete", allValues2);
                            break;

                        default:
                            ResultPropertyValueCollection expandedAttribute = _searchResult.Properties[propertyName];
                            ADPropertySyntaxAndType attributeSyntaxAndType = LDAPUtil.GetProperySyntaxAndType(propertyName);
                            List<string> ParsedAttributeValues = LDAPUtil.ParseAttribute(attributeSyntaxAndType, expandedAttribute);
                            forgeADObject.AddAttribute(propertyName, ParsedAttributeValues);
                            break;
                    }
                }// END PROPERTIES ITERATION

                //TODO: Refactor duplicated code. There may be even more.
                if (specialCaseMember == true)
                {
                    int position = forgeADObject.AttributeNames.IndexOf("member");
                    forgeADObject.AttributeNames.RemoveAt(position);
                    forgeADObject.AttributeValues.RemoveAt(position);
                    int position2 = forgeADObject.AttributeNames.IndexOf("memberComplete");
                    forgeADObject.AttributeNames[position2] = "member";
                }
                if (specialCasemsds_revealedusers == true)
                {
                    int position = forgeADObject.AttributeNames.IndexOf("msds-revealedusers");
                    forgeADObject.AttributeNames.RemoveAt(position);
                    forgeADObject.AttributeValues.RemoveAt(position);
                    int position2 = forgeADObject.AttributeNames.IndexOf("msds-revealedusersComplete");
                    forgeADObject.AttributeNames[position2] = "msds-revealedusers";
                }

                //Console.WriteLine(objectGuid);
                //Console.WriteLine(_forge.Path);

                // Check before adding
                if (AllObjects.ContainsKey(objectGuid))
                {
                    // Change or changes of existing object
                    // Enumerate coming attribute names
                    // Compare with metaverse attribute names list
                    // For new > create change from <not set> to value. type FromChange
                    // For removed > create change from oldValue to <not set>. type FromChange
                    // For common > Iterate, compare, and create change for updated from oldValue to newValue.

                    List<string> NewAttributesList = forgeADObject.AttributeNames;
                    List<string> OldAttributeList = AllObjects[objectGuid].AttributeNames;

                    var newAttributes = NewAttributesList.Except(OldAttributeList, StringComparer.OrdinalIgnoreCase);
                    var emptiedAttributes = OldAttributeList.Except(NewAttributesList, StringComparer.OrdinalIgnoreCase);
                    var commonAttributes = NewAttributesList.Intersect(OldAttributeList, StringComparer.OrdinalIgnoreCase).ToList();
                    Console.WriteLine("INF\tUpdating cache for object: {0}", friendlyName);
                    foreach (var newAttribute in newAttributes)
                    {
                        var a = objectGuid;
                        var b = newAttribute;
                        var c = new List<string>();
                        var d = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf(newAttribute)];
                        var e = DateTime.Now;
                        var f = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf("whenchanged")][0];
                        var g = forgeADObject.USN;
                        var h = LDAPUtil.GetProperySyntaxAndType(newAttribute).isSingleValued;
                        var i = FromNewOrFromChange.FROM_CHANGE;
                        Change _change = new Change(a, b, c, d, e, f, g, h, i, friendlyName, forgeADObject.ObjectClass);
                        Changes.Add(_change);
                        AddToFileCollection(c, d, _change); //TODO: For MAF remove this
                    }

                    foreach (var emptiedAttribute in emptiedAttributes)
                    {
                        var a = objectGuid;
                        var b = emptiedAttribute;
                        var c = AllObjects[objectGuid].AttributeValues[AllObjects[objectGuid].AttributeNames.IndexOf(emptiedAttribute)];
                        var d = new List<string>();
                        var e = DateTime.Now;
                        var f = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf("whenchanged")][0];
                        var g = forgeADObject.USN;
                        var h = LDAPUtil.GetProperySyntaxAndType(emptiedAttribute).isSingleValued;
                        var i = FromNewOrFromChange.FROM_CHANGE;
                        Change _change = new Change(a, b, c, d, e, f, g, h, i, friendlyName, forgeADObject.ObjectClass);
                        Changes.Add(_change);
                        AddToFileCollection(c, d, _change); //TODO: For MAF remove this
                    }

                    foreach (var commonAttribute in commonAttributes)
                    {
                        List<string> oldValues = AllObjects[objectGuid].AttributeValues[AllObjects[objectGuid].AttributeNames.IndexOf(commonAttribute)];
                        List<string> newValues = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf(commonAttribute)];
                        // Common attribute but now different value
                        if (!oldValues.SequenceEqual(newValues))  //TODO: The order of the items alter the equality comparasion
                        {
                            var a = objectGuid;
                            var b = commonAttribute;
                            var c = AllObjects[objectGuid].AttributeValues[AllObjects[objectGuid].AttributeNames.IndexOf(commonAttribute)];
                            var d = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf(commonAttribute)];
                            var e = DateTime.Now;
                            var f = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf("whenchanged")][0];
                            var g = forgeADObject.USN;
                            //var h = LDAPUtil.AttributeSyntaxDecoder[commonAttribute].IsSingleValued;
                            var h = LDAPUtil.GetProperySyntaxAndType(commonAttribute).isSingleValued;
                            var i = FromNewOrFromChange.FROM_CHANGE;
                            Change _change = new Change(a, b, c, d, e, f, g, h, i, friendlyName, forgeADObject.ObjectClass);
                            Changes.Add(_change);
                            AddToFileCollection(c, d, _change); //TODO: For MAF remove this
                        }
                    }

                    //Replace entry in the cache
                    AllObjects.Remove(objectGuid);
                    AllObjects.Add(objectGuid, forgeADObject);

                    //columnsNotInSecond = firstHeaders.Except(secondHeaders).ToList();
                    //remainGUIDs.IntersectWith(secondGUIDs);
                }
                else
                {
                    AllObjects.Add(objectGuid, forgeADObject);
                    if (DirectoryState.GetDBInitialized() == false)
                    {
                        AllObjects[objectGuid].SetLifeCycle(LifeCycle.INITIAL);
                    }
                    else
                    {
                        AllObjects[objectGuid].SetLifeCycle(LifeCycle.NEW);
                        foreach (var newAttribute in AllObjects[objectGuid].AttributeNames)
                        {
                            var a = objectGuid;
                            var b = newAttribute;
                            var c = new List<string>();
                            var d = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf(newAttribute)];
                            var e = DateTime.Now;
                            var f = forgeADObject.AttributeValues[forgeADObject.AttributeNames.IndexOf("whenchanged")][0];
                            var g = forgeADObject.USN;
                            var h = LDAPUtil.GetProperySyntaxAndType(newAttribute).isSingleValued;
                            var i = FromNewOrFromChange.FROM_NEW;
                            Change _change = new Change(a, b, c, d, e, f, g, h, i, friendlyName, forgeADObject.ObjectClass);
                            Changes.Add(_change);
                        }
                    }
                }
            }

            // If is not in the metaverse, it is a new object > Add > report change
            // if it is there, there is one or multiple changes
            // we are not detecting deleted objects here
        } // END AddADObject method

        private static void AddToFileCollection(List<string> c, List<string> d, Change _change)
        {
            //TODO: Added a quick file logger for MAF issue. Remove this or improve it.
            string oldvvv = "";
            string newvvv = "";
            foreach (string ov in c)
            {
                oldvvv += ov + "|";
            }
            // is oldvvv empty, blank or null?
            if (!string.IsNullOrWhiteSpace(oldvvv) && oldvvv.Last() == '|') oldvvv = oldvvv.Remove(oldvvv.Length - 1);

            foreach (string nv in d)
            {
                newvvv += nv + "|";
            }
            if (!string.IsNullOrWhiteSpace(newvvv) && newvvv.Last() == '|') newvvv = newvvv.Remove(newvvv.Length - 1);

            string outputline = _change.FriendlyName + "\t" + _change.AttributeName + "\t" + oldvvv + "\t" + newvvv;

            using (StreamWriter sw = File.AppendText(changesLogFile)) { sw.WriteLine(outputline); }
            //changesLogLines.Add(_change. + "\t" + _change.AttributeName + "\t" + oldvvv + "\t" + newvvv); //TODO: Save periodically using this collection

        }

        public int CountCacheObjects()
        {
            return AllObjects.Count;
        }

        public Guid[] ListGuidObjects()
        {
            // List all keys Allobjects
            return AllObjects.Keys.ToArray();
        }

        public string[] ListAllsAMAccountName()
        {
            List<string> result = new List<string>();
            foreach (var item in AllObjects)
            {
                var attributeNames = item.Value.AttributeNames;
                for (int i = 0; i < attributeNames.Count; i++)
                {
                    var attribute = attributeNames[i];
                    if (attribute.Equals("sAMAccountName", StringComparison.CurrentCultureIgnoreCase))
                    {
                        result.Add(item.Value.AttributeValues[i][0]);
                    }
                }
            }
            return result.ToArray();
        }

        public UserDTO[] ListAllUsers()
        {
            List<UserDTO> userDTOs = new List<UserDTO>();
            foreach (var item in AllObjects)
            {
                if (item.Value.ObjectClass == ADObjectClass.USER)
                {
                    UserDTO _tempUserDTO = new UserDTO();
                    _tempUserDTO.guid = item.Key.ToString();
                    var attributeNames = item.Value.AttributeNames;
                    for (int i = 0; i < attributeNames.Count; i++)
                    {
                        var attribute = attributeNames[i];
                        if (attribute.Equals("sAMAccountName", StringComparison.CurrentCultureIgnoreCase))
                        {
                            _tempUserDTO.sAMAccountName = item.Value.AttributeValues[i][0];
                        }
                        if (attribute.Equals("displayName", StringComparison.CurrentCultureIgnoreCase))
                        {
                            _tempUserDTO.displayName = item.Value.AttributeValues[i][0];
                        }
                    }
                    userDTOs.Add(_tempUserDTO);
                }
            }
            return userDTOs.ToArray();
        }

        public string[] ListAllChanges()
        {
            return ModifiedObjects.ToArray();
        }

        public Change[] ListAllChanges2()
        {
            return Changes.ToArray();
        }

        public GuidChangesAggregated[] ListAllChanges3()
        {
            //TODO: comparing delta attributes for DNs will throw wrong results if DN of objects is changed, like rename CN of a user
            // Enumerate all changes
            // Split by object guid
            // for every single attribute show old and new
            // for every multi-attribute
            //    compare both lists and report only removed and added with a label
            lock (changesLock)
            {
                List<GuidChangesAggregated> result = new List<GuidChangesAggregated>();

                foreach (var item in Changes) // Foreach change
                {
                    var guid = item.guid;
                    bool existsAlready = result.Any(result => result.Guid == guid);

                    if (existsAlready) // If it is already in the list
                    {
                    }
                    else // if it is not in the list of guids
                    {
                        GuidChangesAggregated _tempChangeCompact = new GuidChangesAggregated();
                        _tempChangeCompact.FriendlyName = item.FriendlyName;
                        _tempChangeCompact.Guid = item.guid;
                        _tempChangeCompact.ObjectClass = item.ObjectClass;

                        var changesByGuid = Changes.Where(c => c.guid == guid).ToArray();
                        List<ChangeCompactAttribute> _tempChangeCompactAttributeList = new List<ChangeCompactAttribute>();
                        foreach (var change in changesByGuid) // for each change associated with the same guid
                        {
                            if (change.AttributeName == "whenchanged") continue;

                            ChangeCompactAttribute _tempChangeCompactAttribute = new ChangeCompactAttribute();
                            _tempChangeCompactAttribute.AttributeName = change.AttributeName;
                            _tempChangeCompactAttribute.OldValues = change.OldValues;
                            _tempChangeCompactAttribute.NewValues = change.NewValues;
                            _tempChangeCompactAttribute.IsSingleOrMulti = change.IsSingleOrMulti;
                            _tempChangeCompactAttribute.WhenChangedWhenDetected = change.WhenChangedWhenDetected;

                            List<string> _tempDeltaValues = new List<string>();
                            if (change.IsSingleOrMulti == false || change.AttributeName == "useraccountcontrol") //multivalue
                            {
                                var emptiedAttributes = change.OldValues.Except(change.NewValues, StringComparer.OrdinalIgnoreCase);
                                var newAttributes = change.NewValues.Except(change.OldValues, StringComparer.OrdinalIgnoreCase);
                                var commonAttributes = change.NewValues.Intersect(change.OldValues, StringComparer.OrdinalIgnoreCase).ToList();
                                foreach (var addedItem in emptiedAttributes) { _tempDeltaValues.Add(@"(-)" + addedItem); }
                                foreach (var removedItem in newAttributes) { _tempDeltaValues.Add(@"(+)" + removedItem); }
                            }
                            _tempChangeCompactAttribute.DeltaValues = _tempDeltaValues;

                            _tempChangeCompactAttributeList.Add(_tempChangeCompactAttribute);
                        }
                        _tempChangeCompact.ChangeCompactAttributes = _tempChangeCompactAttributeList;
                        result.Add(_tempChangeCompact);
                    }

                    //Console.WriteLine(item);
                }
                return result.ToArray();
            }
            //GuidChangesAggregated[] array = Array.Empty<GuidChangesAggregated>();
            //return array;
        }

        public int CountUsers()
        {
            int countUsers = AllObjects.Values.Where(x => x.ObjectClass == ADObjectClass.USER).Count();
            return countUsers;
        }

        public int CountGroups()
        {
            int countGroups = AllObjects.Values.Where(x => x.ObjectClass == ADObjectClass.GROUP).Count();
            return countGroups;
        }

        public int CountContacts()
        {
            int countContacts = AllObjects.Values.Where(x => x.ObjectClass == ADObjectClass.CONTACT).Count();
            return countContacts;
        }

        public int CountComputers()
        {
            int countComputers = AllObjects.Values.Where(x => x.ObjectClass == ADObjectClass.COMPUTER).Count();
            return countComputers;
        }

        public int CountOUs()
        {
            int countOUs = AllObjects.Values.Where(x => x.ObjectClass == ADObjectClass.OU).Count();
            return countOUs;
        }

        public int CountOthers()
        {
            int countOthers = AllObjects.Values.Where(x => x.ObjectClass == ADObjectClass.UNKNOWN).Count();
            return countOthers;
        }
    }
}

//TODO: Monitor DN for not changed accounts. This is very interesting scenario. If you move a container the objects inside get new DN but no change registered by AD