﻿using myADMonitor.Helpers;
using System.Diagnostics;
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
        private readonly List<string> attributesToIgnore;
        private readonly object changesLock = new object();

        // MAF
        public string changesLogFile;
        public List<string> changesLogLines;
        public string filesPath;

        public Metaverse()
        {
            Console.WriteLine("----------------------------- myADMonitor 0.6 ----------------------------");
            Console.WriteLine("Starting...");

            // Initialize collections
            AllObjects = new Dictionary<Guid, ADObject>();
            ModifiedObjects = new List<string>();
            Changes = new List<Change>();

            // Set attributes to ignore
            attributesToIgnore = new List<string>() { "msds-revealedusers" }; //TODO: Enhancement, test the solution work for this attribute for RDOC
            //TODO: Right now attributesToIgnore is not used, but it could be used to avoid logging some attributes
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
        //TODO: Optimization techniques
        //Save only the unique part of the DN, and compute the rest later
        //Save only the unique part for Path, and compute the rest later
        //Create a list of attribute names and save only an index to the list List<string> guarantees order
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
                    //if (propertyName == "whenchanged") Debugger.Break();
                    if (DirectoryState.ShouldIgnoreAttribute(propertyName))
                    {
                        continue;
                    }
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
                                    //UACFlagsActiveAsStrings.Add(Enum.GetName(typeof(UserAccountControl), flagDetector));
                                    UACFlagsActiveAsStrings.Add(Enum.GetName(typeof(UserAccountControl), flagDetector) ?? "ERROR_DETECTING_USERACCOUNTCONTROL_FLAG " + flagDetector.ToString());
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
                            var allValues = LDAPUtil.EnumerateLargeProperty(_searchResult.Properties["adspath"][0].ToString()!, "member");
                            forgedADObject.AddAttribute("memberComplete", allValues);

                            // SPECIAL CASE GROUP +1500 members
                            // Generated a new ParsedAttributeValues for propery member
                            break;

                        case "msds-revealedusers;range=0-1499":
                            Console.WriteLine("strange case msds-revealedusers;range=0-1499");
                            specialCasemsds_revealedusers = true;
                            Console.WriteLine("WARNING:\tLarge msds-revealedusers attribute detected +1500 members." + propertyName);
                            var allValues2 = LDAPUtil.EnumerateLargeProperty(
                                _searchResult.Properties["adspath"][0].ToString()!,
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
                    if (position >= 0)
                    {
                        forgedADObject.AttributeNames.RemoveAt(position);
                        forgedADObject.AttributeValues.RemoveAt(position);
                    }
                    int position2 = forgedADObject.AttributeNames.IndexOf("memberComplete");
                    if (position2 >= 0)
                    {
                        forgedADObject.AttributeNames[position2] = "member";
                    }
                }
                if (specialCasemsds_revealedusers == true)
                {
                    int position = forgedADObject.AttributeNames.IndexOf("msds-revealedusers");
                    if (position >= 0)
                    {
                        forgedADObject.AttributeNames.RemoveAt(position);
                        forgedADObject.AttributeValues.RemoveAt(position);
                    }
                    int position2 = forgedADObject.AttributeNames.IndexOf("msds-revealedusersComplete");
                    if (position2 >= 0)
                    {
                        forgedADObject.AttributeNames[position2] = "msds-revealedusers";
                    }
                }
                // -4- check if the objects is in the metaverse, and add/remove/update attributes from the change happening.... Update by replacing the metaverse object
                // TODO: Change to TryGetValue for huge gains and avoid double lookup
                if (AllObjects.TryGetValue(objectGuid, out ADObject? value))
                {
                    // Old attributes & new attributes >>> Compute lists of new, empited and common attributes
                    List<string> OldAttributeList = value.AttributeNames;
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
                        int newAttributeIndex = forgedADObject.AttributeNames.IndexOf(newAttribute);
                        var _newValues = newAttributeIndex >= 0 ? forgedADObject.AttributeValues[newAttributeIndex] : new List<string>();
                        int whenChangedIndex = forgedADObject.AttributeNames.IndexOf("whenchanged");
                        var _whenChanged = whenChangedIndex >= 0 && forgedADObject.AttributeValues[whenChangedIndex].Count > 0
                            ? forgedADObject.AttributeValues[whenChangedIndex][0]
                            : string.Empty;
                        var _whenDetected = DateTime.Now;                        
                        var _currentUSN = forgedADObject.USN;
                        var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(newAttribute).IsSingleValued;
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
                        int emptiedAttributeIndex = value.AttributeNames.IndexOf(emptiedAttribute);
                        var _oldValues = emptiedAttributeIndex >= 0 ? value.AttributeValues[emptiedAttributeIndex] : new List<string>();
                        var _NewValuesEmpty = new List<string>(); // New values is just the attribute empty
                        var _whenDetected = DateTime.Now;
                        int whenChangedIndex = forgedADObject.AttributeNames.IndexOf("whenchanged");
                        var _whenChanged = whenChangedIndex >= 0 && forgedADObject.AttributeValues[whenChangedIndex].Count > 0
                            ? forgedADObject.AttributeValues[whenChangedIndex][0]
                            : string.Empty;
                        var _currentUSN = forgedADObject.USN;
                        var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(emptiedAttribute).IsSingleValued;
                        var _fromNewOrFromChange = FromNewOrFromChange.FROM_CHANGE;
                        Change _change = new Change(_guid, _emptiedAttribute, _oldValues, _NewValuesEmpty, _whenDetected, _whenChanged, _currentUSN, _singleOrMulti, _fromNewOrFromChange, friendlyName, forgedADObject.ObjectClass);
                        Changes.Add(_change);
                        AddToFileCollection(_oldValues, _NewValuesEmpty, _change); //TODO: For MAF remove this
                    }
                    // -5c- Update attributes changed on the object...
                    foreach (var commonAttribute in commonAttributes)
                    {
                        int oldAttributeIndex = value.AttributeNames.IndexOf(commonAttribute);
                        int newAttributeIndex = forgedADObject.AttributeNames.IndexOf(commonAttribute);
                        List<string> oldValues = oldAttributeIndex >= 0 ? value.AttributeValues[oldAttributeIndex] : new List<string>();
                        List<string> newValues = newAttributeIndex >= 0 ? forgedADObject.AttributeValues[newAttributeIndex] : new List<string>();
                        // Common attribute but now different value
                        if (!oldValues.SequenceEqual(newValues))  //TODO: The order of the items alter the equality comparasion. Need to sort first here or somewhere else
                        {
                            var _guid = objectGuid;
                            var _commonAttribute = commonAttribute;
                            var _oldValues = oldAttributeIndex >= 0 ? value.AttributeValues[oldAttributeIndex] : new List<string>();
                            var _newValues = newAttributeIndex >= 0 ? forgedADObject.AttributeValues[newAttributeIndex] : new List<string>();
                            var _whenDetected = DateTime.Now;
                            int whenChangedIndex = forgedADObject.AttributeNames.IndexOf("whenchanged");
                            var _whenChanged = whenChangedIndex >= 0 && forgedADObject.AttributeValues[whenChangedIndex].Count > 0
                                ? forgedADObject.AttributeValues[whenChangedIndex][0]
                                : string.Empty;
                            var _currentUSN = forgedADObject.USN; //TODO: find how many times this USN is used, I have the impression is not required.                            
                            var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(commonAttribute).IsSingleValued;
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
                            int newAttributeIndex = forgedADObject.AttributeNames.IndexOf(newAttribute);
                            var _newValues = newAttributeIndex >= 0 ? forgedADObject.AttributeValues[newAttributeIndex] : new List<string>();
                            var _whenDetected = DateTime.Now;
                            int whenChangedIndex = forgedADObject.AttributeNames.IndexOf("whenchanged");
                            var _whenChanged = whenChangedIndex >= 0 && forgedADObject.AttributeValues[whenChangedIndex].Count > 0
                                ? forgedADObject.AttributeValues[whenChangedIndex][0]
                                : string.Empty;
                            var _currentUSN = forgedADObject.USN;
                            var _singleOrMulti = LDAPUtil.GetProperySyntaxAndType(newAttribute).IsSingleValued;
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

        private void AddToFileCollection(List<string> oldValues, List<string> newValues, Change change)
        {
            //TODO: Added a quick file logger for MAF issue. Remove this or improve it.
            //TODO: Detect tabs on the attributes because TSV
            //TODO: Use join instead of foreach and remove last char
            //string oldValuesConcatenated = string.Join("|", oldValues);
            //string newValuesConcatenated = string.Join("|", newValues);

            //string outputLine = $"{change.FriendlyName}\t{change.AttributeName}\t{oldValuesConcatenated}\t{newValuesConcatenated}";

            //using (StreamWriter sw = File.AppendText(changesLogFile))
            //{
            //    sw.WriteLine(outputLine);
            //}
            string oldvvv = "";
            string newvvv = "";
            foreach (string ov in oldValues)
            {
                oldvvv += ov + "|";
            }
            // is oldvvv empty, blank or null?
            if (!string.IsNullOrWhiteSpace(oldvvv) && oldvvv.Last() == '|') oldvvv = oldvvv.Remove(oldvvv.Length - 1);

            foreach (string nv in newValues)
            {
                newvvv += nv + "|";
            }
            if (!string.IsNullOrWhiteSpace(newvvv) && newvvv.Last() == '|') newvvv = newvvv.Remove(newvvv.Length - 1);

            string outputline = change.FriendlyName + "\t" + change.AttributeName + "\t" + oldvvv + "\t" + newvvv;

            using StreamWriter sw = File.AppendText(changesLogFile);
            sw.WriteLine(outputline);             //changesLogLines.Add(_change. + "\t" + _change.AttributeName + "\t" + oldvvv + "\t" + newvvv); //TODO: Save periodically using this collection

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
                    UserDTO _tempUserDTO = new UserDTO
                    {
                        guid = item.Key.ToString()
                    };
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

                foreach (var item in Changes) 
                {
                    var guid = item.guid;
                    bool existsAlready = result.Any(result => result.Guid == guid);

                    if (existsAlready)
                    {
                        //WHY: This exist because for each guid it will computer in an inner loop the changes. This is not efficient. 
                    }
                    else // if it is not in the list of guids
                    {
                        GuidChangesAggregated _tempChangeCompact = new GuidChangesAggregated
                        {
                            FriendlyName = item.FriendlyName,
                            Guid = item.guid,
                            ObjectClass = item.ObjectClass
                        };

                        var changesByGuid = Changes.Where(c => c.guid == guid).ToArray();
                        List<ChangeCompactAttribute> _tempChangeCompactAttributeList = new List<ChangeCompactAttribute>();
                        foreach (var change in changesByGuid) // for each change associated with the same guid
                        {
                            if (change.AttributeName == "whenchanged") continue;

                            ChangeCompactAttribute _tempChangeCompactAttribute = new ChangeCompactAttribute
                            {
                                AttributeName = change.AttributeName,
                                OldValues = change.OldValues,
                                NewValues = change.NewValues,
                                IsSingleOrMulti = change.IsSingleOrMulti,
                                WhenChangedWhenDetected = change.WhenChangedWhenDetected
                            };

                            List<string> _tempDeltaValues = new List<string>();
                            if (change.IsSingleOrMulti == false || change.AttributeName == "useraccountcontrol") //multivalue
                            {
                                var emptiedAttributes = change.OldValues.Except(change.NewValues, StringComparer.OrdinalIgnoreCase);
                                var newAttributes = change.NewValues.Except(change.OldValues, StringComparer.OrdinalIgnoreCase);
                                var commonAttributes = change.NewValues.Intersect(change.OldValues, StringComparer.OrdinalIgnoreCase).ToList();
                                foreach (var addedItem in emptiedAttributes) { _tempDeltaValues.Add("(-)" + addedItem); }
                                foreach (var removedItem in newAttributes) { _tempDeltaValues.Add("(+)" + removedItem); }
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
        public GuidChangesAggregated[]  ListChangesApplyAllFilters(string? objectClasses, string? objectNameFilter, string? attributeFilter, string? showOnlyFilteredAttribute)
        {
            List<GuidChangesAggregated> result = new List<GuidChangesAggregated>();
            string[] objectClassesArray = [];
            string nameFilterFinal = objectNameFilter ?? "";
            string attributeFilterFinal = attributeFilter ?? "";
            bool showOnlyFilteredAttributeFinal = showOnlyFilteredAttribute == "true";

            bool filterByObjectClasses = false;
            bool filterByName = false;
            bool filterByAttribute = false;


            if (string.IsNullOrEmpty(objectClasses) && string.IsNullOrEmpty(objectNameFilter) && string.IsNullOrEmpty(attributeFilter))
            {
                // Return all changes from ListAllChanges3()
                return result.ToArray();
            }

            if(!string.IsNullOrEmpty(objectClasses))
            {
                filterByObjectClasses = true;
                objectClassesArray = objectClasses.Split(',');
            }
            if(!string.IsNullOrEmpty(objectNameFilter)) //TODO: Double check if I need to use objectNameFilter or the final version on these 3 ifs
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
                    allChanges = allChanges.Where(c => c.FriendlyName.Contains(nameFilterFinal, StringComparison.OrdinalIgnoreCase)).ToArray();
                }
                // if filterByAttribute is true, remove from allChanges the ones that do not contain attributeFilterFinal
                if (filterByAttribute)
                {
                    allChanges = allChanges.Where(c => c.ChangeCompactAttributes.Any(a => a.AttributeName.Contains(attributeFilterFinal, StringComparison.OrdinalIgnoreCase))).ToArray();
                    if(showOnlyFilteredAttributeFinal)
                    {

                        for (int i = 0; i < allChanges.Length; i++)
                        {
                            var change = allChanges[i];
                            change.ChangeCompactAttributes = change.ChangeCompactAttributes.Where(a => a.AttributeName.Contains(attributeFilterFinal, StringComparison.OrdinalIgnoreCase)).ToList();
                        }
                    }
                }
            }

            return allChanges.ToArray();
        }

        public int CountUsers()
        {
            int countUsers = AllObjects.Values.Count(x => x.ObjectClass == ADObjectClass.USER);
            return countUsers;
        }

        public int CountGroups()
        {
            int countGroups = AllObjects.Values.Count(x => x.ObjectClass == ADObjectClass.GROUP);
            return countGroups;
        }

        public int CountContacts()
        {
            int countContacts = AllObjects.Values.Count(x => x.ObjectClass == ADObjectClass.CONTACT);
            return countContacts;
        }

        public int CountComputers()
        {
            int countComputers = AllObjects.Values.Count(x => x.ObjectClass == ADObjectClass.COMPUTER);
            return countComputers;
        }

        public int CountOUs()
        {
            int countOUs = AllObjects.Values.Count(x => x.ObjectClass == ADObjectClass.OU);
            return countOUs;
        }

        public int CountOthers()
        {
            int countOthers = AllObjects.Values.Count(x => x.ObjectClass == ADObjectClass.UNKNOWN);
            return countOthers;
        }
    }
}

//TODO: Monitor DN for not changed accounts. This is very interesting scenario. If you move a container the objects inside get new DN but no change registered by AD
//TODO: Clasify the interOrgPerson not as user