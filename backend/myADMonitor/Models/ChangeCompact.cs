namespace myADMonitor.Models
{
    public class GuidChangesAggregated
    {
        public Guid Guid { get; set; }
        public string FriendlyName { get; set; }
        public List<ChangeCompactAttribute> ChangeCompactAttributes { get; set; }
        public string ObjectClass { get; set; }
    }

    public enum FromNewOrFromChange2
    {
        FROM_NEW,
        FROM_CHANGE
    }

    public class ChangeCompactAttribute
    {
        // Attribute name
        // Multiple changes old and new
        public string AttributeName { get; set; }

        public List<string> OldValues { get; set; }
        public List<string> NewValues { get; set; }
        public bool IsSingleOrMulti { get; set; }
        public string WhenChangedWhenDetected { get; set; }
        public List<string> DeltaValues { get; set; }
    }
}