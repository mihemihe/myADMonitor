# myADMonitor

myADMonitor is an open-source Active Directory changes tracking tool. It gives you almost real-time visibility on changes commited to your Active Directory domain.

![alt text](/blob/Example01.png?raw=true)


## Table of Contents
- [Features](#features)


## Features
- __Auto-configuration:__ Automatically discovers your local AD Domain and a Domain Controller in the local Active Directory site.
- __Customizable:__ Config file to customize runtime settings, such as Domain Controller or custom LDAP query
- __Front-end Agnostic:__ Changes feed are presented as a REST API. Default front-end included is based on a simple React site
- __Calculated diff for multi-value attributes:__ Familiar Red/Green (+)/(-) formats to represent old and new values for multi-value attributes

