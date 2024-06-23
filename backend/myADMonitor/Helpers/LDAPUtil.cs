//using ActiveDs; for security descriptors. This causes issues later with publish
using System;
using System.Collections;
using System.DirectoryServices;
using System.DirectoryServices.ActiveDirectory;
using System.Security.Principal;
using myADMonitor.Models;
using myADMonitor.Helpers;

#pragma warning disable CA1416 // Validate platform compatibility
namespace myADMonitor.Helpers
{
    public static class LDAPUtil
    {        
        public static Dictionary<string,int> metrics = new Dictionary<string,int>();
        public static Dictionary<string, ActiveDirectorySchemaProperty> SchemaAttributesCodex = new(StringComparer.InvariantCultureIgnoreCase);

        public static SearchResultCollection LDAPSearchCollection(string query, string ldappath)
        {
            DirectoryEntry customDirectoryEntry = new DirectoryEntry(ldappath);
            DirectorySearcher myDirectorySearcher = new(customDirectoryEntry, query);

            myDirectorySearcher.PageSize = 1000;
            //myDirectorySearcher.SizeLimit = 50; //TODO: Remove the limit 
            //myDirectorySearcher.PropertiesToLoad.Add("msDS-AllowedToActOnBehalfOfOtherIdentity");
            SearchResultCollection resultCollection = myDirectorySearcher.FindAll();
            return resultCollection;

        }

        public static void InitAttributeSyntaxTable()
        {
            //ReadOnlyActiveDirectorySchemaPropertyCollection directoryProperties;

            // TODO: Investigate why Trimming unused code on publishing makes this fail
            DirectoryContext context = new DirectoryContext(DirectoryContextType.Forest);            
            var directorySchema = ActiveDirectorySchema.GetSchema(context);
            var directoryProperties = directorySchema.FindAllProperties();           

            foreach (ActiveDirectorySchemaProperty property in directoryProperties)
            {
                // Name is the one matching Active Directory attribute names (case does not match tho!!)
                //Console.WriteLine(property.Name + " " + property.Syntax + " " + property.IsSingleValued);
                SchemaAttributesCodex.Add(property.Name, property);

            }
            // Code below to find the syntax of a particular attribute.
            //var a = AttributeSyntaxDecoder.Where(x => x.Value?.Syntax is not null).Select(x => x.Value.Syntax).ToList();
            //var b = a.Distinct();                      
            ////Special syntax for linked with more than 5k
            //var c = AttributeSyntaxDecoder["userAccountControl"];
            //foreach (var ads in b)
            //{

            //    metrics.Add(ads.ToString(), 0);
                
            //}


        }

        public static List<string> EnumerateLargeProperty(string ldapPath, string attribute)
        {
            //"LDAP://CN=largegroup,OU=ddddd,DC=DOMAIN01,DC=LOCAL"
            //string attribute = "member";
            List<string> al = new List<string>();
            DirectoryEntry entry = new DirectoryEntry(ldapPath);
            int step = entry.Properties[attribute].Count - 1;
            int idx = 0;
            string range = String.Format("{0};range={{0}}-{{1}}", attribute);
            string currentRange = String.Format(range, idx, step);
            string[] propertiesToLoad = new string[] { currentRange };            
            DirectorySearcher searcher = new DirectorySearcher(entry, String.Format("({0}=*)", attribute), propertiesToLoad, System.DirectoryServices.SearchScope.Base);


            bool lastSearch = false;
            SearchResult sr = null;
            while (true)
            {
                if (!lastSearch)
                {
                    searcher.PropertiesToLoad.Clear();
                    searcher.PropertiesToLoad.Add(currentRange);
                    sr = searcher.FindOne();
                }
                if (sr != null)
                {
                    if (sr.Properties.Contains(currentRange))
                    {
                        Console.WriteLine("INFO\tElements found in this range of 1500 elements: " + sr.Properties[currentRange].Count);
                        foreach (object dn in sr.Properties[currentRange])
                        {
                            al.Add(dn.ToString());
                            idx++;
                        }
                        //our exit condition
                        if (lastSearch)
                            break;
                        currentRange = String.Format(range, idx, (idx + step));
                    }
                    else
                    {
                        //one more search
                        lastSearch = true;
                        currentRange = String.Format(range, idx, "*");
                    }
                }
                else
                    break;
            }

            return al;

        }

        public static ADPropertySyntaxAndType GetProperySyntaxAndType(string propertyName)
        {
            ADPropertySyntaxAndType syntaxAndType = new ADPropertySyntaxAndType();
            ActiveDirectorySyntax ADSyntax;
            bool isSingleValued;

            //TODO: We moved this here, but later we handled the member +1500 in metaverse. This
            //      may slow down the app.
            
            if (SchemaAttributesCodex.TryGetValue(propertyName, out ActiveDirectorySchemaProperty propSyntaxDetails))  //new Out C# 7
            {
                ADSyntax = propSyntaxDetails.Syntax;
                isSingleValued = LDAPUtil.SchemaAttributesCodex[propertyName].IsSingleValued;
                //Console.WriteLine("Fetched value: {0}", propSyntaxDetails);
            }
            else
            {
                switch (propertyName)
                {

                    case "member;range=0-1499":
                        ADSyntax = ActiveDirectorySyntax.DN;
                        isSingleValued = false;
                        Console.WriteLine("stop");
                        break;
                    case "msds-revealedusers;range=0-1499":
                        //TODO: Investigate DNWithBinary and if it is false or true This attribute is used by RODC
                        ADSyntax = ActiveDirectorySyntax.DNWithBinary;
                        isSingleValued = false;
                        Console.WriteLine("stop");
                        break;
                    default:
                        ADSyntax = ActiveDirectorySyntax.DN;
                        isSingleValued = false;
                        Console.WriteLine(">>>>>>>> stop!!!!!. We dont know this attribute syntax: " + propertyName);
                        break;
                }

                Console.WriteLine("No such key: {0}", propertyName);
            }
            syntaxAndType.ADSyntax = ADSyntax;
            syntaxAndType.isSingleValued = isSingleValued;
            return syntaxAndType;
        }

        public static string LDAPQueryRangeGenerator(long lower, long upper)
        {            
            return "(&(usnChanged>=" + lower + ")(usnChanged<=" + upper + ")" + DirectoryState.runConfig.LDAPQuery + ")";
        }

        public static List<string> ParseAttribute(ADPropertySyntaxAndType syntaxAndType, ResultPropertyValueCollection _expandedPropertiesCollection)
        {
            List<string> __tempAttributeValues = new();
            
            switch (syntaxAndType.ADSyntax, syntaxAndType.isSingleValued)
            {
                case (ActiveDirectorySyntax.Bool, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.CaseIgnoreString, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());
                    break;                                        
                case (ActiveDirectorySyntax.DirectoryString, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());
                    break;
                case (ActiveDirectorySyntax.DN, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());
                    break;
                case (ActiveDirectorySyntax.DNWithBinary, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.DNWithString, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.Enumeration, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString()); //TODO find and test an example                    
                    break;
                case (ActiveDirectorySyntax.GeneralizedTime, true):
                    DateTime tempTime = (DateTime)_expandedPropertiesCollection[0];
                    string tempTimeString =
                        tempTime.Year.ToString() + "/" +
                        tempTime.Month.ToString() + "/" +
                        tempTime.Day.ToString() + " " +
                        tempTime.Hour.ToString() + ":" +
                        tempTime.Minute.ToString() + ":" +
                        tempTime.Second.ToString() + " UTC";
                    __tempAttributeValues.Add(tempTimeString);
                    break;
                case (ActiveDirectorySyntax.IA5String, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString() + "(IA5)");                    
                    break;
                case (ActiveDirectorySyntax.Int, true):                    //
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());
                    break;
                case (ActiveDirectorySyntax.Int64, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());
                    break;
                case (ActiveDirectorySyntax.NumericString, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.OctetString, true):
                    byte[] objectGuidByteFormat2 = (byte[])_expandedPropertiesCollection[0];
                    if (objectGuidByteFormat2.Length == 16)
                    {
                        Guid objectGuid2 = new Guid(objectGuidByteFormat2); //TOODO, missing the 2 in variable name?
                        __tempAttributeValues.Add(objectGuid2.ToString());
                        //Console.WriteLine(objectGuid2.ToString());
                    }
                    else
                    {
                        //Console.WriteLine(BitConverter.ToString(objectGuidByteFormat2));
                        __tempAttributeValues.Add(BitConverter.ToString(objectGuidByteFormat2));
                    }
                    break;
                case (ActiveDirectorySyntax.Oid, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.PresentationAddress, true):
                    Console.WriteLine("STOP");
                    break;
                case (ActiveDirectorySyntax.PrintableString, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.ReplicaLink, true):
                    __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());                    
                    break;
                case (ActiveDirectorySyntax.SecurityDescriptor, true):
                    Console.WriteLine("STOP");
                    break;
                case (ActiveDirectorySyntax.Sid, true):
                    var sidInBytes = (byte[])_expandedPropertiesCollection[0];
                    var sid = new SecurityIdentifier(sidInBytes, 0);
                    // This gives you what you want
                    __tempAttributeValues.Add(sid.ToString());
                    break;
                case (ActiveDirectorySyntax.UtcTime, true): // TODO: find an attribute with this syntax to test. whenChanged does not use this syntax
                    Console.WriteLine("STOP");
                    break;
                    
                // vvvvvvvvvvvvvvvvvv MULTIVALUES BELOW vvvvvvvvvvvvv
                
                case (ActiveDirectorySyntax.Bool, false):                    
                    foreach (string directoryString in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(directoryString);
                    }                    
                    break;
                case (ActiveDirectorySyntax.CaseIgnoreString, false):
                    foreach (string directoryString in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(directoryString);
                    }                    
                    break;
                case (ActiveDirectorySyntax.DirectoryString, false):
                    foreach (string directoryString in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(directoryString);
                    }
                    break;
                case (ActiveDirectorySyntax.DN, false):
                    foreach (string dn in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(dn);
                    }
                    break;
                case (ActiveDirectorySyntax.DNWithBinary, false):
                    //var yyy = (string)_expandedPropertiesCollection[0];
                    //var uuu = DNWithBinary.Parse(yyy);                    
                    foreach (string s in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(s);
                    }
                    break;
                case (ActiveDirectorySyntax.DNWithString, false):
                    foreach (string s in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(s);
                    }                    
                    break;
                case (ActiveDirectorySyntax.Enumeration, false):
                    foreach (var s in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(s.ToString());
                    }                    
                    break;
                case (ActiveDirectorySyntax.GeneralizedTime, false):
                    foreach (DateTime timestamp in _expandedPropertiesCollection)
                    {
                        string tempTimeString2 =
                            timestamp.Year.ToString() + "/" +
                            timestamp.Month.ToString() + "/" +
                            timestamp.Day.ToString() + " " +
                            timestamp.Hour.ToString() + ":" +
                            timestamp.Minute.ToString() + ":" +
                            timestamp.Second.ToString() + " UTC";
                        __tempAttributeValues.Add(tempTimeString2);
                    }
                    break;
                case (ActiveDirectorySyntax.IA5String, false):
                    foreach (var s in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(s + "(IA5)");
                        __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString() + "(IA5)");
                    }                    
                    break;
                case (ActiveDirectorySyntax.Int, false):
                    foreach (int s in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(s.ToString());
                    }                    
                    break;
                case (ActiveDirectorySyntax.Int64, false):
                    foreach (var s in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(s.ToString());
                    }                    
                    break;
                case (ActiveDirectorySyntax.NumericString, false):
                    foreach (string s in _expandedPropertiesCollection) { 
                        __tempAttributeValues.Add(_expandedPropertiesCollection[0].ToString());
                    }            
                    break;
                case (ActiveDirectorySyntax.OctetString, false):
                    foreach (var octetString in _expandedPropertiesCollection)
                    {
                        var OctetStringInBytes = (byte[])octetString;
                        __tempAttributeValues.Add(BitConverter.ToString(OctetStringInBytes));
                    }
                    break;
                case (ActiveDirectorySyntax.Oid, false):
                    foreach (string oid in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(oid);
                    }
                    break;
                case (ActiveDirectorySyntax.PresentationAddress, false):                    
                    break;
                case (ActiveDirectorySyntax.PrintableString, false):
                    foreach (string oid in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(oid);
                    }                    
                    break;
                case (ActiveDirectorySyntax.ReplicaLink, false): //TODO: This is Byte[] but we hack it to string 
                    foreach (var oid in _expandedPropertiesCollection)
                    {
                        __tempAttributeValues.Add(oid.ToString());
                    }                    
                    break;
                case (ActiveDirectorySyntax.SecurityDescriptor, false):                    
                    break;
                case (ActiveDirectorySyntax.Sid, false):                    
                    break;
                case (ActiveDirectorySyntax.UtcTime, false):                    
                    break;
                    
                //ADDED LATER 
                case (ActiveDirectorySyntax.ORName, true):                    
                    break;
                case (ActiveDirectorySyntax.ORName, false):                    
                    break;
                default:
                    Console.WriteLine("combo not found");
                    break;
            }

            return __tempAttributeValues;
        }

        public static ADObjectClass GetClass(ResultPropertyValueCollection classes)
        {
            ADObjectClass objectClass = ADObjectClass.UNKNOWN;

            if (classes.Contains("computer"))
            {
                objectClass = ADObjectClass.COMPUTER;
            }
            else if (classes.Contains("contact"))
            {
                objectClass = ADObjectClass.CONTACT;
            }
            else if (classes.Contains("group"))
            {
                objectClass = ADObjectClass.GROUP;
            }
            else if (classes.Contains("organizationalUnit"))
            {
                objectClass = ADObjectClass.OU;
            }
            else if (classes.Contains("user") && !classes.Contains("computer"))
            {
                objectClass = ADObjectClass.USER;
            }
            return objectClass;
        }
    }
}
#pragma warning restore CA1416 // Validate platform compatibility