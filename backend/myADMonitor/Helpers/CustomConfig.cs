namespace myADMonitor.Helpers
{
    public interface CustomConfig
    {
        string DomainControllerFQDN { get; }
        string LDAPQuery { get; }
        string ListenAllIPs { get; }
        string TCPPort { get; }

    }
}