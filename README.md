# myADMonitor

myADMonitor is an open-source Active Directory changes tracking tool. It gives you almost real-time visibility on changes commited to your Active Directory domain.

![alt text](/blob/Example01.png?raw=true)


## Table of Contents
- [Quick-Start](#quick-start)
- [Features](#features)
- [FAQ](#faq)


## Features
- __Auto-configuration:__ Automatically discovers your local AD Domain and a Domain Controller in the local Active Directory site.
- __Customizable:__ Config file to customize runtime settings, such as Domain Controller or custom LDAP query
- __Front-end Agnostic:__ Changes feed are presented as a REST API. Default front-end included is based on a simple React site
- __Calculated diff for multi-value attributes:__ Familiar Red/Green (+)/(-) formats to represent old and new values for multi-value attributes

## Quick-Start

- Extract the release zip file 
- (Optional) Edit the config.ini file
- Execute myADMonitor.exe
- Open your browser and navigate to https://localhost:5001


## FAQ
### myADMonitor cannot find a close domain controller
Edit the config.ini file and hardcode a reachable Domain Controller

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
