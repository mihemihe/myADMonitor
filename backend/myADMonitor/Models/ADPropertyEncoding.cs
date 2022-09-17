using System.DirectoryServices.ActiveDirectory;

namespace myADMonitor.Models
{
    public class ADPropertyEncoding
    {
        public ActiveDirectorySyntax ADSyntax { get; set; }
        public bool isSingleValued { get; set; }
    }
}
