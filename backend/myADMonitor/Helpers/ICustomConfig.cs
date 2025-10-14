namespace myADMonitor.Helpers
{
    public interface ICustomConfig
    {
        string DomainControllerFQDN { get; }
        string LDAPQuery { get; }
        string ListenAllIPs { get; }
        string TCPPort { get; }
        string AttributesFiltered { get; }

    }
}