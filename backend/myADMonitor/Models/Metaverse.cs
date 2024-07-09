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
                // -1- Compose basic object identification attributes and a friendly name...
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
                ADObject forgedADObject = new ADObject(objectGuid, path, dn, friendlyName);
                //Console.WriteLine("");
                //Console.WriteLine(friendlyName);


                // -2- For each property in the object...
                foreach (string propertyName in _searchResult.Properties.PropertyNames)
                {
                    //Console.WriteLine(propertyName);
                    switch (propertyName)
                    {
                        case "useraccountcontrol":
                            //Console.WriteLine("useraccountcontrol");
                            // Create enum with all useraccountcontrol values
                            // decode as binary flag
                            List<string> UACFlagsActiveAsStrings = new List<string>();
                            int currentUAC = (int)_searchResult.Properties["useraccountControl"][0];

                            foreach (int flag in Enum.GetValues(typeof(UserAccountControl)))
                            {
                                int flagDetector = (currentUAC & flag);
                                //Console.WriteLine($" {flag}");
                                //Console.WriteLine("Result &: " + flagDetector.ToString());
                                if (flagDetector > 0)
                                {
                                    //Console.WriteLine(Enum.GetName(typeof(UserAccountControl), flagDetector));
                                    UACFlagsActiveAsStrings.Add(Enum.GetName(typeof(UserAccountControl), flagDetector));
                                }
                            }
                            forgedADObject.AddAttribute(propertyName, UACFlagsActiveAsStrings);
                            break;

                        case "usnchanged":

                            forgedADObject.USN = (long)_searchResult.Properties[propertyName][0];

                            //  Console.WriteLine(_forge.USN + "  <=> TOP USN: " + DirectoryState.GetCurrentUSN());

                            break;

                        case "objectclass":
                            forgedADObject.ObjectClass = LDAPUtil.GetClass(_searchResult.Properties[propertyName]);
                            break;

                        case "adspath":
                            break;

                        case "member;range=0-1499": //TODO: change this to something more generic, old AD maybe different
                            specialCaseMember = true;
                            Console.WriteLine("WARNING:\tLarge member attribute detected +1500 members." + propertyName);
                            var allValues = LDAPUtil.EnumerateLargeProperty(_searchResult.Properties["adspath"][0].ToString(), "member");
                            forgedADObject.AddAttribute("memberComplete", allValues);

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
                            forgedADObject.AddAttribute("msds-revealedusersComplete", allValues2);
                            break;

                        default:
                            ResultPropertyValueCollection expandedAttribute = _searchResult.Properties[propertyName];
                            ADPropertySyntaxAndType attributeSyntaxAndType = LDAPUtil.GetProperySyntaxAndType(propertyName);
                            List<string> ParsedAttributeValues = LDAPUtil.ParseAttribute(attributeSyntaxAndType, expandedAttribute);
                            forgedADObject.AddAttribute(propertyName, ParsedAttributeValues);
                            break;
                    }
                }// END PROPERTIES ITERATION

                //TODO: Refactor duplicated code. There may be even more.
                // -3- Handle special cases such as large linked attributes (member>1500, RDOC revealed users)...
                if (specialCaseMember == true)
                {
                    int position = forgedADObject.AttributeNames.IndexOf("member");
                    forgedADObject.AttributeNames.RemoveAt(position);
                    forgedADObject.AttributeValues.RemoveAt(position);
                    int position2 = forgedADObject.AttributeNames.IndexOf("memberComplete");
                    forgedADObject.AttributeNames[position2] = "member";
                }
                if (specialCasemsds_revealedusers == true)
                {
                    int position = forgedADObject.AttributeNames.IndexOf("msds-revealedusers");
                    forgedADObject.AttributeNames.RemoveAt(position);
                    forgedADObject.AttributeValues.RemoveAt(position);
                    int position2 = forgedADObject.AttributeNames.IndexOf("msds-revealedusersComplete");
                    forgedADObject.AttributeNames[position2] = "msds-revealedusers";
                }


                // -4- check if the objects is in the metaverse, and add/remove/update attributes from the change happening.... Update by replacing the metaverse object
                // TODO: Change to TryGetValue for huge gains and avoid double lookup
                if (AllObjects.ContainsKey(objectGuid))
                {
                    // Old attributes & new attributes >>> Compute lists of new, empited and common attributes
                    List<string> OldAttributeList = AllObjects[objectGuid].AttributeNames;
                    List<string> NewAttributesList = forgedADObject.AttributeNames;
                    var newAttributes = NewAttributesList.Except(OldAttributeList, StringComparer.OrdinalIgnoreCase);
                    var emptiedAttributes = OldAttributeList.Except(NewAttributesList, StringComparer.OrdinalIgnoreCase);
                    var commonAttributes = NewAttributesList.Intersect(OldAttributeList, StringComparer.OrdinalIgnoreCase).ToList();
                    Console.WriteLine("INF\tUpdating cache for object: {0}", friendlyName);
                    // -5a- New attributes to add to the object...
                    foreach (var newAttribute in newAttributes)
                    {
                        var _guid = objectGuid;
                        var _newAttribute = newAttribute;
                        var _fromEmptyOldValues = new List<string>();
                        var _newValues = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf(newAttribute)];
                        var _whenDetected = DateTime.Now;
                        var _whenChanged = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf("whenchanged")][0];
                        var _currentUSN = forgedADObject.USN;
                        var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(newAttribute).isSingleValued;
                        var _fromNewOrFromChange = FromNewOrFromChange.FROM_CHANGE;
                        Change _change = new Change(_guid, _newAttribute, _fromEmptyOldValues, _newValues, _whenDetected, _whenChanged, _currentUSN, _singleOrMulti, _fromNewOrFromChange, friendlyName, forgedADObject.ObjectClass);
                        Changes.Add(_change);
                        AddToFileCollection(_fromEmptyOldValues, _newValues, _change); //TODO: For MAF remove this
                    }
                    // -5b- Remove attributes cleared from the object...
                    foreach (var emptiedAttribute in emptiedAttributes)
                    {
                        var _guid = objectGuid;
                        var _emptiedAttribute = emptiedAttribute;
                        var _oldValues = AllObjects[objectGuid].AttributeValues[AllObjects[objectGuid].AttributeNames.IndexOf(emptiedAttribute)];
                        var _NewValuesEmpty = new List<string>(); // New values is just the attribute empty
                        var _whenDetected = DateTime.Now;
                        var _whenChanged = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf("whenchanged")][0];
                        var _currentUSN = forgedADObject.USN;
                        var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(emptiedAttribute).isSingleValued;
                        var _fromNewOrFromChange = FromNewOrFromChange.FROM_CHANGE;
                        Change _change = new Change(_guid, _emptiedAttribute, _oldValues, _NewValuesEmpty, _whenDetected, _whenChanged, _currentUSN, _singleOrMulti, _fromNewOrFromChange, friendlyName, forgedADObject.ObjectClass);
                        Changes.Add(_change);
                        AddToFileCollection(_oldValues, _NewValuesEmpty, _change); //TODO: For MAF remove this
                    }
                    // -5c- Update attributes changed on the object...
                    foreach (var commonAttribute in commonAttributes)
                    {
                        List<string> oldValues = AllObjects[objectGuid].AttributeValues[AllObjects[objectGuid].AttributeNames.IndexOf(commonAttribute)];
                        List<string> newValues = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf(commonAttribute)];
                        // Common attribute but now different value
                        if (!oldValues.SequenceEqual(newValues))  //TODO: The order of the items alter the equality comparasion. Need to sort first here or somewhere else
                        {
                            var _guid = objectGuid;
                            var _commonAttribute = commonAttribute;
                            var _oldValues = AllObjects[objectGuid].AttributeValues[AllObjects[objectGuid].AttributeNames.IndexOf(commonAttribute)];
                            var _newValues = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf(commonAttribute)];
                            var _whenDetected = DateTime.Now;
                            var _whenChanged = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf("whenchanged")][0];
                            var _currentUSN = forgedADObject.USN; //TODO: find how many times this USN is used, I have the impression is not required.                            
                            var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(commonAttribute).isSingleValued;
                            var _fromNewOrFromChange = FromNewOrFromChange.FROM_CHANGE;
                            Change _change = new Change(_guid, _commonAttribute, _oldValues, _newValues, _whenDetected, _whenChanged, _currentUSN, _singleOrMulti, _fromNewOrFromChange, friendlyName, forgedADObject.ObjectClass);
                            Changes.Add(_change);
                            AddToFileCollection(_oldValues, _newValues, _change); //TODO: For MAF remove this
                        }
                    }

                    //If it was part of the searchResult, and existed in the metaverse, there are changes and we need to replace it on the metaverse. 
                    AllObjects.Remove(objectGuid);
                    AllObjects.Add(objectGuid, forgedADObject);

                }
                else
                {
                    //TODO: NEw users are not logged on the file
                    //If it was part of the searchResult, and did NOT exist in the metaverse, is a new object to add to the metaverse, either created or first sync
                    // We set below the LifeCycle status (either NEW or INITIAL) and if new, we track all new attributes as changes
                    AllObjects.Add(objectGuid, forgedADObject);

                    if (DirectoryState.GetDBInitialized() == false)
                    {
                        AllObjects[objectGuid].SetLifeCycle(LifeCycle.INITIAL);
                    }
                    else
                    {
                        AllObjects[objectGuid].SetLifeCycle(LifeCycle.NEW);
                        foreach (var newAttribute in AllObjects[objectGuid].AttributeNames)
                        {
                            var _guid = objectGuid;
                            var _newAttribute = newAttribute;
                            var _fromEmptyOldValues = new List<string>();
                            var _newValues = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf(newAttribute)];
                            var _whenDetected = DateTime.Now;
                            var _whenChanged = forgedADObject.AttributeValues[forgedADObject.AttributeNames.IndexOf("whenchanged")][0];
                            var _currentUSN = forgedADObject.USN;
                            var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(newAttribute).isSingleValued;
                            var _fromNewOrFromChange = FromNewOrFromChange.FROM_NEW;
                            Change _change = new Change(_guid, _newAttribute, _fromEmptyOldValues, _newValues, _whenDetected, _whenChanged, _currentUSN, _singleOrMulti, _fromNewOrFromChange, friendlyName, forgedADObject.ObjectClass);
                            Changes.Add(_change);
                            AddToFileCollection(_fromEmptyOldValues, _newValues, _change);
                        }
                    }
                }
            }
            // TODO: Detect deleted items
        } // END AddOrUpdateObject method

        private static void AddToFileCollection(List<string> c, List<string> d, Change _change)
        {
            //TODO: Added a quick file logger for MAF issue. Remove this or improve it.
            //TODO: Detect tabs on the attributes because TSV
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

        public GuidChangesAggregated[] ListAllChangesByObjectClass(string objectClasses)
        {
            List<GuidChangesAggregated> result = new List<GuidChangesAggregated>();
            var objectClassesArray = objectClasses.Split(',');
            lock (changesLock)
            {
                // call GuidChangesAggregated[] ListAllChanges3()
                // filter by objectClasses
                var allChanges = ListAllChanges3();
                foreach (var item in allChanges)
                {
                    if (objectClassesArray.Contains(item.ObjectClass))
                    {
                        result.Add(item);
                    }
                }
            }
            return result.ToArray();
        }

        //http://localhost:5000/api/v1/adupdates/get-changes?objectclass=USER&textFilter=a&attributeFilter=a&showOnlyFilteredAttribute=true
        //http://localhost:5000/api/v1/adupdates/get-changes?objectclass=USER%2CGROUP%2CCONTACT%2CCOMPUTER%2COU%2CUNKNOWN&textFilter=dddddd&attributeFilter=ddddd&showOnlyFilteredAttribute=true
        //objectclass=USER,COMPUTER,CONTACT,GROUP,OU,UNKNOWN
        //textFilter=a
        //attributeFilter=a
        //showOnlyFilteredAttribute=true
        public GuidChangesAggregated[]  ListChangesApplyAllFilters(string? objectClasses, string? nameFilter, string? attributeFilter, string? showOnlyFilteredAttribute)
        {
            List<GuidChangesAggregated> result = new List<GuidChangesAggregated>();
            string[] objectClassesArray = [];
            string nameFilterFinal = nameFilter ?? "";
            string attributeFilterFinal = attributeFilter ?? "";
            bool onlyShowFilteredAttributes = showOnlyFilteredAttribute == "true";

            bool filterByObjectClasses = false;
            bool filterByName = false;
            bool filterByAttribute = false;
            


            if (string.IsNullOrEmpty(objectClasses) && string.IsNullOrEmpty(nameFilter) && string.IsNullOrEmpty(attributeFilter))
            {
                // Return all changes from ListAllChanges3()
                return result.ToArray();
            }
            
            if(!string.IsNullOrEmpty(objectClasses))
            {
                filterByObjectClasses = true;
                objectClassesArray = objectClasses.Split(',');
            }
            if(!string.IsNullOrEmpty(nameFilter))
            {
                filterByName = true;
            }
            if(!string.IsNullOrEmpty(attributeFilter))
            {
                filterByAttribute = true;
            }
            GuidChangesAggregated[]? allChanges = [];
            lock (changesLock)
            {
                allChanges = ListAllChanges3();
                // if filterByObjectClasses is true, remove from allChanges the ones that are not in objectClassesArray
                if(filterByObjectClasses)
                {
                    allChanges = allChanges.Where(c => objectClassesArray.Contains(c.ObjectClass)).ToArray();
                }
                // if filterByName is true, remove from allChanges the ones that do not contain nameFilterFinal
                if (filterByName)
                {
                    allChanges = allChanges.Where(c => c.FriendlyName.IndexOf(nameFilterFinal, StringComparison.OrdinalIgnoreCase) >= 0).ToArray();
                }
                // if filterByAttribute is true, remove from allChanges the ones that do not contain attributeFilterFinal
                if (filterByAttribute)
                {
                    allChanges = allChanges.Where(c => c.ChangeCompactAttributes.Any(a => a.AttributeName.IndexOf(attributeFilterFinal, StringComparison.OrdinalIgnoreCase) >= 0)).ToArray();
                    if(onlyShowFilteredAttributes)
                    {

                        for (int i = 0; i < allChanges.Length; i++)
                        {
                            var change = allChanges[i];                            
                            change.ChangeCompactAttributes = change.ChangeCompactAttributes.Where(a => a.AttributeName.IndexOf(attributeFilterFinal, StringComparison.OrdinalIgnoreCase) >= 0).ToList();
                        }
                    }
                }
            }

            return allChanges.ToArray();
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
//TODO: Clasify the interOrgPerson not as user