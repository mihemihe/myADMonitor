namespace myADMonitor.Models
{
    public class ADObject
    {
        public string DN;
        public string ShortName;
        public Guid GUID;
        public string Path;
        public List<string> AttributeNames = new();
        public List<List<string>> AttributeValues = new();
        public ADObjectClass ObjectClass;
        public long USN;
        public LifeCycle ObjectLifeCycle;

        public ADObject(Guid _guid, string _path, string dn, string shortname)
        {
            GUID = _guid;
            Path = _path;
            DN = dn;
            ShortName = shortname;

            //TODO: Parse the incoming objets and create the dictionary
        }

        public void AddAttribute(string name, List<string> value)
        {
            AttributeNames.Add(name);
            AttributeValues.Add(value);
        }

        public void SetLifeCycle(LifeCycle lifeCycle)
        {
            ObjectLifeCycle = lifeCycle;
        }

        public void RemoveEmptyMember()
        {
        }
    }

    public enum ADObjectClass
    {
        USER,
        COMPUTER,
        CONTACT,
        GROUP,
        OU,
        UNKNOWN
    }

    public enum LifeCycle
    {
        INITIAL,
        NEW,
        DELETED,
        RESTORED
    }

    
    enum UserAccountControl : int
    {
        SCRIPT = 1,
        ACCOUNTDISABLE = 2,
        HOMEDIR_REQUIRED = 8,
        LOCKOUT = 16,
        PASSWD_NOTREQD = 32,
        PASSWD_CANT_CHANGE = 64,
        ENCRYPTED_TEXT_PWD_ALLOWED = 128,
        TEMP_DUPLICATE_ACCOUNT = 256,
        NORMAL_ACCOUNT = 512,
        INTERDOMAIN_TRUST_ACCOUNT = 2048,
        WORKSTATION_TRUST_ACCOUNT = 4096,
        SERVER_TRUST_ACCOUNT = 8192,
        DONT_EXPIRE_PASSWORD = 65536,
        MNS_LOGON_ACCOUNT = 131072,
        SMARTCARD_REQUIRED = 262144,
        TRUSTED_FOR_DELEGATION = 524288,
        NOT_DELEGATED = 1048576,
        USE_DES_KEY_ONLY = 2097152,
        DONT_REQ_PREAUTH = 4194304,
        PASSWORD_EXPIRED = 8388608,
        TRUSTED_TO_AUTH_FOR_DELEGATION = 16777216,
        PARTIAL_SECRETS_ACCOUNT = 67108864
    };
}