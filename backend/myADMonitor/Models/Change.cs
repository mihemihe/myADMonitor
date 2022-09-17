namespace myADMonitor.Models
{
    public class Change
    {
        public Guid guid { get; set; }
        public string AttributeName { get; set; }
        public List<string> OldValues { get; set; }
        public List<string> NewValues { get; set; }
        public DateTime WhenDetected { get; set; }
        public string WhenChangedWhenDetected { get; set; }
        public long USN { get; set; }
        public bool IsSingleOrMulti { get; set; }
        public FromNewOrFromChange FromNewOrChange { get; set; }
        public string FriendlyName { get; set; }
        public string ObjectClass { get; set; }

        public Change(Guid _guid,
            string attributeName,
            List<string> oldValues,
            List<string> newValues,
            DateTime whenDetected,
            string whenChangedWhenDetected,
            long uSN,
            bool isSingleOrMulti,
            FromNewOrFromChange fromNewOrChange,
            string friendlyName,
            ADObjectClass objectClass)
        {
            guid = _guid;
            AttributeName = attributeName;
            OldValues = oldValues;
            NewValues = newValues;
            WhenDetected = whenDetected;
            WhenChangedWhenDetected = whenChangedWhenDetected;
            USN = uSN;
            IsSingleOrMulti = isSingleOrMulti;
            FromNewOrChange = fromNewOrChange;
            FriendlyName = friendlyName;
            ObjectClass = objectClass.ToString();
        }
    }

    public enum FromNewOrFromChange
    {
        FROM_NEW,
        FROM_CHANGE
    }
}