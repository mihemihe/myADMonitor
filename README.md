# myADMonitor

myADMonitor is an open-source Active Directory changes tracking tool. It gives you almost real-time visibility on changes commited to your Active Directory domain.

![alt text](/blob/Example01.png?raw=true)


## Table of Contents
- [Quick-Start](#quick-start)
- [Features](#features)
- [FAQ](#faq)
- [Known Issues and Limitations](#knownissuesandlimitations)


## Features
- __Auto-configuration:__ Automatically discovers your local AD Domain and a Domain Controller in the local Active Directory site.
- __Customizable:__ Config file to customize runtime settings, such as Domain Controller or custom LDAP query
- __Front-end agnostic:__ Changes feed are presented as a REST API. Out-of-the-box front-end is based on a simple React site
- __Calculated diff for multi-value attributes:__ Familiar Red/Green (+)/(-) formats to represent old and new values for multi-value attributes

## Quick-Start

- Extract the release zip file 
- (Optional) Edit the config.ini file
- Execute myADMonitor.exe
- Open your browser and navigate to http://localhost:5000 (on Chrome, Firefox or Edge. Old Internet Explorer versions may not work)


## FAQ
### myADMonitor cannot find a close domain controller automatically
myADMonitor will try to find a domain controller in the same AD Site, of no one is found, then it will try to reach any Domain Controller in the Domain. If none of the Domain Controllers are reachable, it will close. However, if you prefer to configure a fixed Domain Controller, edit the config.ini file tiwh your prefered Domain Controller.

### Does myADMonitor require special permissions to run?
No, only read-only should be enough for most of the cases. 

### Does myADMonitor track changes on passwords?
Password changes are tracked because pwdLastSet and whenChanged attributes are changed, but password values (hashes) are not tracked

### How myADMonitor works internally?
- On initialization a reachable Domain Controller is found
- Schema attributes are enumerated and stored to parse the multiple attributes' syntax
- Active Directory is queried for all USN from 0 up to the latest USN detected.
- All objects are cached on memory during the initialization, based.
- At regular intervals, Active Directory is queried for USN changes and pulls and stores those changes in memory
- The chanes collection is published via the REST API

### The program can't start because api-ms-win-crt-string-l1-1-0.dll is missing from your computer. Try reinstalling the program to fix this problem.
Some old Windows operating systems may require an update of the C Universal Runtime
There are two solutions:
- Update the server using Windows Update
- Download and update the Universal C Runtime directly from : https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-322bf30f-4735-bb94-3949-49f5c49f4732

## Known issues and limitations

### Deleted objects are not tracked. This is in the roadmap. 
### ntSecurityDescriptor (AKA Object permissions) are not tracked. This is also in the roadmap.
