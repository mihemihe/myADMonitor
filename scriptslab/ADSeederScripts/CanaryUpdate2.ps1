# I want to create a script to modify an AD account with sAMAccountName "canary"
# I am enumerating all the properties possible for the class user
# The properties will be modified one by one not with an collection of properties
$sam = "canary"
$container = "OU=perf,DC=megacorp,DC=local"
# concatenate but with a forward slash
$dn = "CN=$sam,$container"

# check if the user exists, and if so, delete it and recreate it with the minimum required properties and with the sAMAccountName "canary"
if (Get-ADUser -Filter {sAMAccountName -eq $sam}) {
    Remove-ADUser -Identity $dn -Confirm:$false
}

# create the user with the minimum required properties, on the $container, with a random password
New-ADUser -SamAccountName $sam -Name $sam -GivenName $sam -Surname $sam `
 -DisplayName $sam -AccountPassword (ConvertTo-SecureString -AsPlainText "Password123!" -Force) -Enabled $true -ChangePasswordAtLogon $true -Path $container


$attributeNames = @(
"accountNameHistory"
"aCSPolicyName"
"adminDescription"
"adminDisplayName"
"attributeCertificateAttribute"
"audio"
"businessCategory"
"c"
"carLicense"
"co"
"comment"
"company"
"department"
"departmentNumber"
"description"
"desktopProfile"
"destinationIndicator"
"displayName"
"displayNamePrintable"
"division"
"employeeID"
"employeeNumber"
"employeeType"
"extensionName"
"facsimileTelephoneNumber"
"generationQualifier"
"givenName"
"groupMembershipSAM"
"groupPriority"
"groupsToIgnore"
"homeDirectory"
"homeDrive"
"homePhone"
"homePostalAddress"
"houseIdentifier"
"info"
"ipPhone"
"jpegPhoto"
"l"
"labeledURI"
"logonWorkstation"
"mail"
"mhsORAddress"
"middleName"
"mobile"
"mS-DS-ConsistencyGuid"
"msDRM-IdentityCertificate"
"msDS-ExternalDirectoryObjectId"
"msDS-PhoneticCompanyName"
"msDS-PhoneticDepartment"
"msDS-PhoneticDisplayName"
"msDS-PhoneticFirstName"
"msDS-PhoneticLastName"
"msDS-SourceAnchor"
"msDS-SourceObjectDN"
"msDS-SyncServerUrl"
"msExchAssistantName"
"msExchHouseIdentifier"
"msExchLabeledURI"
"msIIS-FTPDir"
"msIIS-FTPRoot"
"mSMQSignCertificates"
"mSMQSignCertificatesMig"
"msNPCallingStationID"
"msNPSavedCallingStationID"
"msPKIRoamingTimeStamp"
"msRADIUS-FramedIpv6Route"
"msRADIUS-SavedFramedIpv6Route"
"msRADIUSCallbackNumber"
"msRADIUSFramedRoute"
"msRASSavedCallbackNumber"
"msRASSavedFramedRoute"
"msSFU30Name"
"msSFU30NisDomain"
"msTSHomeDirectory"
"msTSHomeDrive"
"msTSInitialProgram"
"msTSLicenseVersion"
"msTSLicenseVersion2"
"msTSLicenseVersion3"
"msTSLicenseVersion4"
"msTSLSProperty01"
"msTSLSProperty02"
"msTSManagingLS"
"msTSManagingLS2"
"msTSManagingLS3"
"msTSManagingLS4"
"msTSProfilePath"
"msTSProperty01"
"msTSProperty02"
"msTSWorkDirectory"
"networkAddress"
"otherFacsimileTelephoneNumber"
"otherHomePhone"
"otherIpPhone"
"otherLoginWorkstations"
"otherMailbox"
"otherMobile"
"otherPager"
"otherTelephone"
"ou"
"pager"
"personalTitle"
"photo"
"physicalDeliveryOfficeName"
"postalAddress"
"postalCode"
"postOfficeBox"
"preferredLanguage"
"primaryInternationalISDNNumber"
"primaryTelexNumber"
"profilePath"
"proxyAddresses"
"registeredAddress"
"scriptPath"
"serialNumber"
"sn"
"st"
"street"
"streetAddress"
"telephoneNumber"
"teletexTerminalIdentifier"
"telexNumber"
"terminalServer"
"textEncodedORAddress"
"thumbnailLogo"
"thumbnailPhoto"
"title"
"uid"
"unixHomeDirectory"
"unixUserPassword"
"url"
"userCert"
"userCertificate"
"userParameters"
"userPassword"
"userPKCS12"
"userPrincipalName"
"userSharedFolder"
"userSharedFolderOther"
"userSMIMECertificate"
"userWorkstations"
"wbemPath"
"wWWHomePage"
"x121Address"
"x500uniqueIdentifier"
)

foreach ($attributeName in $attributeNames) {
    set-adobject -Identity $dn -replace @{$attributeName=$attributeName + "b"}
}







# Attributes that cannot be changed directly below:

#set-adobject -Identity $dn -replace @{accountExpires="accountExpires"} 
#set-adobject -Identity $dn -replace @{adminCount="adminCount"}
#set-adobject -Identity $dn -replace @{allowedAttributes="allowedAttributes"} #
#set-adobject -Identity $dn -replace @{allowedAttributesEffective="allowedAttributesEffective"}
#set-adobject -Identity $dn -replace @{allowedChildClasses="allowedChildClasses"} #
#set-adobject -Identity $dn -replace @{allowedChildClassesEffective="allowedChildClassesEffective"}
#set-adobject -Identity $dn -replace @{altSecurityIdentities="altSecurityIdentities"}
#set-adobject -Identity $dn -replace @{assistant="assistant"} DN
#set-adobject -Identity $dn -replace @{badPasswordTime="badPasswordTime"}
#set-adobject -Identity $dn -replace @{badPwdCount="badPwdCount"}
#set-adobject -Identity $dn -replace @{bridgeheadServerListBL="bridgeheadServerListBL"}
#set-adobject -Identity $dn -replace @{canonicalName="canonicalName"}
#set-adobject -Identity $dn -replace @{cn="cn"}
#set-adobject -Identity $dn -replace @{codePage="codePage"}
#set-adobject -Identity $dn -replace @{controlAccessRights="controlAccessRights"}
#set-adobject -Identity $dn -replace @{countryCode="countryCode"}
#set-adobject -Identity $dn -replace @{createTimeStamp="createTimeStamp"}
#set-adobject -Identity $dn -replace @{dBCSPwd="dBCSPwd"}
#set-adobject -Identity $dn -replace @{defaultClassStore="defaultClassStore"}
#set-adobject -Identity $dn -replace @{directReports="directReports"}
#set-adobject -Identity $dn -replace @{distinguishedName="distinguishedName"}
#set-adobject -Identity $dn -replace @{dSASignature="dSASignature"}
#set-adobject -Identity $dn -replace @{dSCorePropagationData="dSCorePropagationData"}
#set-adobject -Identity $dn -replace @{dynamicLDAPServer="dynamicLDAPServer"}
#set-adobject -Identity $dn -replace @{flags="flags"}
#set-adobject -Identity $dn -replace @{fromEntry="fromEntry"}
#set-adobject -Identity $dn -replace @{frsComputerReferenceBL="frsComputerReferenceBL"}
#set-adobject -Identity $dn -replace @{fRSMemberReferenceBL="fRSMemberReferenceBL"}
#set-adobject -Identity $dn -replace @{fSMORoleOwner="fSMORoleOwner"}
#set-adobject -Identity $dn -replace @{garbageCollPeriod="garbageCollPeriod"}
#set-adobject -Identity $dn -replace @{gecos="gecos"}
#set-adobject -Identity $dn -replace @{gidNumber="gidNumber"}
#set-adobject -Identity $dn -replace @{initials="initials"}
#set-adobject -Identity $dn -replace @{instanceType="instanceType"}
#set-adobject -Identity $dn -replace @{internationalISDNNumber="internationalISDNNumber"}
#set-adobject -Identity $dn -replace @{isCriticalSystemObject="isCriticalSystemObject"}
#set-adobject -Identity $dn -replace @{isDeleted="isDeleted"}
#set-adobject -Identity $dn -replace @{isPrivilegeHolder="isPrivilegeHolder"}
#set-adobject -Identity $dn -replace @{isRecycled="isRecycled"}
#set-adobject -Identity $dn -replace @{lastKnownParent="lastKnownParent"}
#set-adobject -Identity $dn -replace @{lastLogoff="lastLogoff"}
#set-adobject -Identity $dn -replace @{lastLogon="lastLogon"}
#set-adobject -Identity $dn -replace @{lastLogonTimestamp="lastLogonTimestamp"}
#set-adobject -Identity $dn -replace @{legacyExchangeDN="legacyExchangeDN"}
#set-adobject -Identity $dn -replace @{lmPwdHistory="lmPwdHistory"}
#set-adobject -Identity $dn -replace @{localeID="localeID"}
#set-adobject -Identity $dn -replace @{lockoutTime="lockoutTime"}
#set-adobject -Identity $dn -replace @{loginShell="loginShell"}
#set-adobject -Identity $dn -replace @{logonCount="logonCount"}
#set-adobject -Identity $dn -replace @{logonHours="logonHours"}
#set-adobject -Identity $dn -replace @{managedObjects="managedObjects"}
#set-adobject -Identity $dn -replace @{manager="manager"}
#set-adobject -Identity $dn -replace @{masteredBy="masteredBy"}
#set-adobject -Identity $dn -replace @{maxStorage="maxStorage"}
#set-adobject -Identity $dn -replace @{memberOf="memberOf"}
#set-adobject -Identity $dn -replace @{modifyTimeStamp="modifyTimeStamp"}
#set-adobject -Identity $dn -replace @{"mS-DS-ConsistencyChildCount"="mS-DS-ConsistencyChildCount"}
#set-adobject -Identity $dn -replace @{"mS-DS-CreatorSID"="mS-DS-CreatorSID"}
#set-adobject -Identity $dn -replace @{"msCOM-PartitionSetLink"="msCOM-PartitionSetLink"}
#set-adobject -Identity $dn -replace @{"msCOM-UserLink"="msCOM-UserLink"}
#set-adobject -Identity $dn -replace @{"msCOM-UserPartitionSetLink"="msCOM-UserPartitionSetLink"}
#set-adobject -Identity $dn -replace @{"msDFSR-ComputerReferenceBL"="msDFSR-ComputerReferenceBL"}
#set-adobject -Identity $dn -replace @{"msDFSR-MemberReferenceBL"="msDFSR-MemberReferenceBL"}
#set-adobject -Identity $dn -replace @{"msDS-AllowedToActOnBehalfOfOtherIdentity"="msDS-AllowedToActOnBehalfOfOtherIdentity"}
#set-adobject -Identity $dn -replace @{"msDS-AllowedToDelegateTo"="msDS-AllowedToDelegateTo"}
#set-adobject -Identity $dn -replace @{"msDS-Approx-Immed-Subordinates"="msDS-Approx-Immed-Subordinates"}
#set-adobject -Identity $dn -replace @{"msDS-AssignedAuthNPolicy"="msDS-AssignedAuthNPolicy"}
#set-adobject -Identity $dn -replace @{"msDS-AssignedAuthNPolicySilo"="msDS-AssignedAuthNPolicySilo"}
#set-adobject -Identity $dn -replace @{"msDS-AuthenticatedAtDC"="msDS-AuthenticatedAtDC"}
#set-adobject -Identity $dn -replace @{"msDS-AuthenticatedToAccountlist"="msDS-AuthenticatedToAccountlist"}
#set-adobject -Identity $dn -replace @{"msDS-AuthNPolicySiloMembersBL"="msDS-AuthNPolicySiloMembersBL"}
#set-adobject -Identity $dn -replace @{"msDS-Cached-Membership"="msDS-Cached-Membership"}
#set-adobject -Identity $dn -replace @{"msDS-Cached-Membership-Time-Stamp"="msDS-Cached-Membership-Time-Stamp"}
#set-adobject -Identity $dn -replace @{"msDS-ClaimSharesPossibleValuesWithB"="msDS-ClaimSharesPossibleValuesWithBL"}
#set-adobject -Identity $dn -replace @{"msDS-CloudAnchor"="msDS-CloudAnchor"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute1"="msDS-cloudExtensionAttribute1"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute10"="msDS-cloudExtensionAttribute10"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute11"="msDS-cloudExtensionAttribute11"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute12"="msDS-cloudExtensionAttribute12"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute13"="msDS-cloudExtensionAttribute13"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute14"="msDS-cloudExtensionAttribute14"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute15"="msDS-cloudExtensionAttribute15"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute16"="msDS-cloudExtensionAttribute16"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute17"="msDS-cloudExtensionAttribute17"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute18"="msDS-cloudExtensionAttribute18"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute19"="msDS-cloudExtensionAttribute19"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute2"="msDS-cloudExtensionAttribute2"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute20"="msDS-cloudExtensionAttribute20"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute3"="msDS-cloudExtensionAttribute3"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute4"="msDS-cloudExtensionAttribute4"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute5"="msDS-cloudExtensionAttribute5"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute6"="msDS-cloudExtensionAttribute6"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute7"="msDS-cloudExtensionAttribute7"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute8"="msDS-cloudExtensionAttribute8"}
#set-adobject -Identity $dn -replace @{"msDS-cloudExtensionAttribute9"="msDS-cloudExtensionAttribute9"}
#set-adobject -Identity $dn -replace @{"msDS-EnabledFeatureBL"="msDS-EnabledFeatureBL"}
#set-adobject -Identity $dn -replace @{"msDS-FailedInteractiveLogonCount"="msDS-FailedInteractiveLogonCount"}
#set-adobject -Identity $dn -replace @{"msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon"="msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon"}
#set-adobject -Identity $dn -replace @{"msDS-GeoCoordinatesAltitude"="msDS-GeoCoordinatesAltitude"}
#set-adobject -Identity $dn -replace @{"msDS-GeoCoordinatesLatitude"="msDS-GeoCoordinatesLatitude"}
#set-adobject -Identity $dn -replace @{"msDS-GeoCoordinatesLongitude"="msDS-GeoCoordinatesLongitude"}
#set-adobject -Identity $dn -replace @{"msDS-HABSeniorityIndex"="msDS-HABSeniorityIndex"}
#set-adobject -Identity $dn -replace @{"msDS-HostServiceAccountBL"="msDS-HostServiceAccountBL"}
#set-adobject -Identity $dn -replace @{"msDS-IsDomainFor"="msDS-IsDomainFor"}
#set-adobject -Identity $dn -replace @{"msDS-IsFullReplicaFor"="msDS-IsFullReplicaFor"}
#set-adobject -Identity $dn -replace @{"msDS-IsPartialReplicaFor"="msDS-IsPartialReplicaFor"}
#set-adobject -Identity $dn -replace @{"msDS-IsPrimaryComputerFor"="msDS-IsPrimaryComputerFor"}
#set-adobject -Identity $dn -replace @{"msDS-KeyCredentialLink"="msDS-KeyCredentialLink"}
#set-adobject -Identity $dn -replace @{"msDS-KeyPrincipalBL"="msDS-KeyPrincipalBL"}
#set-adobject -Identity $dn -replace @{"msDS-KeyVersionNumber"="msDS-KeyVersionNumber"}
#set-adobject -Identity $dn -replace @{"msDS-KrbTgtLinkBl"="msDS-KrbTgtLinkBl"}
#set-adobject -Identity $dn -replace @{"msDS-LastFailedInteractiveLogonTime"="msDS-LastFailedInteractiveLogonTime"}
#set-adobject -Identity $dn -replace @{"msDS-LastKnownRDN"="msDS-LastKnownRDN"}
#set-adobject -Identity $dn -replace @{"msDS-LastSuccessfulInteractiveLogonTime"="msDS-LastSuccessfulInteractiveLogonTime"}
#set-adobject -Identity $dn -replace @{"msDS-LocalEffectiveDeletionTime"="msDS-LocalEffectiveDeletionTime"}
#set-adobject -Identity $dn -replace @{"msDS-LocalEffectiveRecycleTime"="msDS-LocalEffectiveRecycleTime"}
#set-adobject -Identity $dn -replace @{"msDs-masteredBy"="msDs-masteredBy"}
#set-adobject -Identity $dn -replace @{"msds-memberOfTransitive"="msds-memberOfTransitive"}
#set-adobject -Identity $dn -replace @{"msDS-MembersForAzRoleBL"="msDS-MembersForAzRoleBL"}
#set-adobject -Identity $dn -replace @{"msDS-MembersOfResourcePropertyListBL"="msDS-MembersOfResourcePropertyListBL"}
#set-adobject -Identity $dn -replace @{"msds-memberTransitive"="msds-memberTransitive"}
#set-adobject -Identity $dn -replace @{"msDS-NC-RO-Replica-Locations-BL"="msDS-NC-RO-Replica-Locations-BL"}
#set-adobject -Identity $dn -replace @{"msDS-NCReplCursors"="msDS-NCReplCursors"}
#set-adobject -Identity $dn -replace @{"msDS-NCReplInboundNeighbors"="msDS-NCReplInboundNeighbors"}
#set-adobject -Identity $dn -replace @{"msDS-NCReplOutboundNeighbors"="msDS-NCReplOutboundNeighbors"}
#set-adobject -Identity $dn -replace @{"msDS-NcType"="msDS-NcType"}
#set-adobject -Identity $dn -replace @{"msDS-NonMembersBL"="msDS-NonMembersBL"}
#set-adobject -Identity $dn -replace @{"msDS-ObjectReferenceBL"="msDS-ObjectReferenceBL"}
#set-adobject -Identity $dn -replace @{"msDS-ObjectSoa"="msDS-ObjectSoa"}
#set-adobject -Identity $dn -replace @{"msDS-OIDToGroupLinkBl"="msDS-OIDToGroupLinkBl"}
#set-adobject -Identity $dn -replace @{"msDS-OperationsForAzRoleBL"="msDS-OperationsForAzRoleBL"}
#set-adobject -Identity $dn -replace @{"msDS-OperationsForAzTaskBL"="msDS-OperationsForAzTaskBL"}
#set-adobject -Identity $dn -replace @{"msDS-parentdistname"="msDS-parentdistname"}
#set-adobject -Identity $dn -replace @{"msDS-preferredDataLocation"="msDS-preferredDataLocation"}
#set-adobject -Identity $dn -replace @{"msDS-PrimaryComputer"="msDS-PrimaryComputer"}
#set-adobject -Identity $dn -replace @{"msDS-PrincipalName"="msDS-PrincipalName"}
#set-adobject -Identity $dn -replace @{"msDS-PSOApplied"="msDS-PSOApplied"}
#set-adobject -Identity $dn -replace @{"msDS-ReplAttributeMetaData"="msDS-ReplAttributeMetaData"}
#set-adobject -Identity $dn -replace @{"msDS-ReplValueMetaData"="msDS-ReplValueMetaData"}
#set-adobject -Identity $dn -replace @{"msDS-ReplValueMetaDataExt"="msDS-ReplValueMetaDataExt"}
#set-adobject -Identity $dn -replace @{"msDS-ResultantPSO"="msDS-ResultantPSO"}
#set-adobject -Identity $dn -replace @{"msDS-RevealedDSAs"="msDS-RevealedDSAs"}
#set-adobject -Identity $dn -replace @{"msDS-RevealedListBL"="msDS-RevealedListBL"}
#set-adobject -Identity $dn -replace @{"msDS-SecondaryKrbTgtNumber"="msDS-SecondaryKrbTgtNumber"}
#set-adobject -Identity $dn -replace @{"msDS-Site-Affinity"="msDS-Site-Affinity"}
#set-adobject -Identity $dn -replace @{"msDS-SupportedEncryptionTypes"="msDS-SupportedEncryptionTypes"}
#set-adobject -Identity $dn -replace @{"msDS-TasksForAzRoleBL"="msDS-TasksForAzRoleBL"}
#set-adobject -Identity $dn -replace @{"msDS-TasksForAzTaskBL"="msDS-TasksForAzTaskBL"}
#set-adobject -Identity $dn -replace @{"msDS-TDOEgressBL"="msDS-TDOEgressBL"}
#set-adobject -Identity $dn -replace @{"msDS-TDOIngressBL"="msDS-TDOIngressBL"}
#set-adobject -Identity $dn -replace @{"msds-tokenGroupNames"="msds-tokenGroupNames"}
#set-adobject -Identity $dn -replace @{"msds-tokenGroupNamesGlobalAndUniversal"="msds-tokenGroupNamesGlobalAndUniversal"}
#set-adobject -Identity $dn -replace @{"msds-tokenGroupNamesNoGCAcceptable"="msds-tokenGroupNamesNoGCAcceptable"}
#set-adobject -Identity $dn -replace @{"msDS-User-Account-Control-Computed"="msDS-User-Account-Control-Computed"}
#set-adobject -Identity $dn -replace @{"msDS-UserPasswordExpiryTimeComputed"="msDS-UserPasswordExpiryTimeComputed"}
#set-adobject -Identity $dn -replace @{"msDS-ValueTypeReferenceBL"="msDS-ValueTypeReferenceBL"}
#set-adobject -Identity $dn -replace @{mSMQDigests="mSMQDigests"}
#set-adobject -Identity $dn -replace @{mSMQDigestsMig="mSMQDigestsMig"}
#set-adobject -Identity $dn -replace @{msNPAllowDialin="msNPAllowDialin"}
#set-adobject -Identity $dn -replace @{"msPKI-CredentialRoamingTokens"="msPKI-CredentialRoamingTokens"}
#set-adobject -Identity $dn -replace @{msPKIAccountCredentials="msPKIAccountCredentials"}
#set-adobject -Identity $dn -replace @{msPKIDPAPIMasterKeys="msPKIDPAPIMasterKeys"}
#set-adobject -Identity $dn -replace @{"msRADIUS-FramedInterfaceId"="msRADIUS-FramedInterfaceId"}
#set-adobject -Identity $dn -replace @{"msRADIUS-FramedIpv6Prefix"="msRADIUS-FramedIpv6Prefix"}
#set-adobject -Identity $dn -replace @{"msRADIUS-SavedFramedInterfaceId"="msRADIUS-SavedFramedInterfaceId"}
#set-adobject -Identity $dn -replace @{"msRADIUS-SavedFramedIpv6Prefix"="msRADIUS-SavedFramedIpv6Prefix"}
#set-adobject -Identity $dn -replace @{msRADIUSFramedIPAddress="msRADIUSFramedIPAddress"}
#set-adobject -Identity $dn -replace @{msRADIUSServiceType="msRADIUSServiceType"}
#set-adobject -Identity $dn -replace @{msRASSavedFramedIPAddress="msRASSavedFramedIPAddress"}
#set-adobject -Identity $dn -replace @{msSFU30PosixMemberOf="msSFU30PosixMemberOf"}
#set-adobject -Identity $dn -replace @{msTSAllowLogon="msTSAllowLogon"}
#set-adobject -Identity $dn -replace @{msTSBrokenConnectionAction="msTSBrokenConnectionAction"}
#set-adobject -Identity $dn -replace @{msTSConnectClientDrives="msTSConnectClientDrives"}
#set-adobject -Identity $dn -replace @{msTSConnectPrinterDrives="msTSConnectPrinterDrives"}
#set-adobject -Identity $dn -replace @{msTSDefaultToMainPrinter="msTSDefaultToMainPrinter"}
#set-adobject -Identity $dn -replace @{msTSExpireDate="msTSExpireDate"}
#set-adobject -Identity $dn -replace @{msTSExpireDate2="msTSExpireDate2"}
#set-adobject -Identity $dn -replace @{msTSExpireDate3="msTSExpireDate3"}
#set-adobject -Identity $dn -replace @{msTSExpireDate4="msTSExpireDate4"}
#set-adobject -Identity $dn -replace @{msTSMaxConnectionTime="msTSMaxConnectionTime"}
#set-adobject -Identity $dn -replace @{msTSMaxDisconnectionTime="msTSMaxDisconnectionTime"}
#set-adobject -Identity $dn -replace @{msTSMaxIdleTime="msTSMaxIdleTime"}
#set-adobject -Identity $dn -replace @{msTSPrimaryDesktop="msTSPrimaryDesktop"}
#set-adobject -Identity $dn -replace @{msTSReconnectionAction="msTSReconnectionAction"}
#set-adobject -Identity $dn -replace @{msTSRemoteControl="msTSRemoteControl"}
#set-adobject -Identity $dn -replace @{msTSSecondaryDesktops="msTSSecondaryDesktops"}
#set-adobject -Identity $dn -replace @{name="name"}
#set-adobject -Identity $dn -replace @{netbootSCPBL="netbootSCPBL"}
#set-adobject -Identity $dn -replace @{nonSecurityMemberBL="nonSecurityMemberBL"}
#set-adobject -Identity $dn -replace @{ntPwdHistory="ntPwdHistory"}
#set-adobject -Identity $dn -replace @{nTSecurityDescriptor="nTSecurityDescriptor"}
#set-adobject -Identity $dn -replace @{o="o"}
#set-adobject -Identity $dn -replace @{objectCategory="objectCategory"}
#set-adobject -Identity $dn -replace @{objectClass="objectClass"}
#set-adobject -Identity $dn -replace @{objectGUID="objectGUID"}
#set-adobject -Identity $dn -replace @{objectSid="objectSid"}
#set-adobject -Identity $dn -replace @{objectVersion="objectVersion"}
#set-adobject -Identity $dn -replace @{operatorCount="operatorCount"}
#set-adobject -Identity $dn -replace @{otherWellKnownObjects="otherWellKnownObjects"}
#set-adobject -Identity $dn -replace @{ownerBL="ownerBL"}
#set-adobject -Identity $dn -replace @{partialAttributeDeletionList="partialAttributeDeletionList"}
#set-adobject -Identity $dn -replace @{partialAttributeSet="partialAttributeSet"}
#set-adobject -Identity $dn -replace @{possibleInferiors="possibleInferiors"}
#set-adobject -Identity $dn -replace @{preferredDeliveryMethod="preferredDeliveryMethod"}
#set-adobject -Identity $dn -replace @{preferredOU="preferredOU"}
#set-adobject -Identity $dn -replace @{primaryGroupID="primaryGroupID"}
#set-adobject -Identity $dn -replace @{proxiedObjectName="proxiedObjectName"}
#set-adobject -Identity $dn -replace @{pwdLastSet="pwdLastSet"}
#set-adobject -Identity $dn -replace @{queryPolicyBL="queryPolicyBL"}
#set-adobject -Identity $dn -replace @{replPropertyMetaData="replPropertyMetaData"}
#set-adobject -Identity $dn -replace @{replUpToDateVector="replUpToDateVector"}
#set-adobject -Identity $dn -replace @{repsFrom="repsFrom"}
#set-adobject -Identity $dn -replace @{repsTo="repsTo"}
#set-adobject -Identity $dn -replace @{revision="revision"}
#set-adobject -Identity $dn -replace @{rid="rid"}
#set-adobject -Identity $dn -replace @{roomNumber="roomNumber"}
#########################set-adobject -Identity $dn -replace @{sAMAccountName="sAMAccountName"}
#set-adobject -Identity $dn -replace @{sAMAccountType="sAMAccountType"}
#set-adobject -Identity $dn -replace @{sDRightsEffective="sDRightsEffective"}
#set-adobject -Identity $dn -replace @{secretary="secretary"}
#set-adobject -Identity $dn -replace @{securityIdentifier="securityIdentifier"}
#set-adobject -Identity $dn -replace @{seeAlso="seeAlso"}
#set-adobject -Identity $dn -replace @{serverReferenceBL="serverReferenceBL"}
#set-adobject -Identity $dn -replace @{servicePrincipalName="servicePrincipalName"}
#set-adobject -Identity $dn -replace @{shadowExpire="shadowExpire"}
#set-adobject -Identity $dn -replace @{shadowFlag="shadowFlag"}
#set-adobject -Identity $dn -replace @{shadowInactive="shadowInactive"}
#set-adobject -Identity $dn -replace @{shadowLastChange="shadowLastChange"}
#set-adobject -Identity $dn -replace @{shadowMax="shadowMax"}
#set-adobject -Identity $dn -replace @{shadowMin="shadowMin"}
#set-adobject -Identity $dn -replace @{shadowWarning="shadowWarning"}
#set-adobject -Identity $dn -replace @{showInAddressBook="showInAddressBook"}
#set-adobject -Identity $dn -replace @{showInAdvancedViewOnly="showInAdvancedViewOnly"}
#set-adobject -Identity $dn -replace @{sIDHistory="sIDHistory"}
#set-adobject -Identity $dn -replace @{siteObjectBL="siteObjectBL"}
#set-adobject -Identity $dn -replace @{structuralObjectClass="structuralObjectClass"}
#set-adobject -Identity $dn -replace @{subRefs="subRefs"}
#set-adobject -Identity $dn -replace @{subSchemaSubEntry="subSchemaSubEntry"}
#set-adobject -Identity $dn -replace @{supplementalCredentials="supplementalCredentials"}
#set-adobject -Identity $dn -replace @{systemFlags="systemFlags"}
#set-adobject -Identity $dn -replace @{tokenGroups="tokenGroups"}
#set-adobject -Identity $dn -replace @{tokenGroupsGlobalAndUniversal="tokenGroupsGlobalAndUniversal"}
#set-adobject -Identity $dn -replace @{tokenGroupsNoGCAcceptable="tokenGroupsNoGCAcceptable"}
#set-adobject -Identity $dn -replace @{uidNumber="uidNumber"}
#set-adobject -Identity $dn -replace @{unicodePwd="unicodePwd"}
#set-adobject -Identity $dn -replace @{userAccountControl="userAccountControl"}
#set-adobject -Identity $dn -replace @{uSNChanged="uSNChanged"}
#set-adobject -Identity $dn -replace @{uSNCreated="uSNCreated"}
#set-adobject -Identity $dn -replace @{uSNDSALastObjRemoved="uSNDSALastObjRemoved"}
#set-adobject -Identity $dn -replace @{USNIntersite="USNIntersite"}
#set-adobject -Identity $dn -replace @{uSNLastObjRem="uSNLastObjRem"}
#set-adobject -Identity $dn -replace @{uSNSource="uSNSource"}
#set-adobject -Identity $dn -replace @{wellKnownObjects="wellKnownObjects"}
#set-adobject -Identity $dn -replace @{whenChanged="whenChanged"}
#set-adobject -Identity $dn -replace @{whenCreated="whenCreated"}




<#
Name
accountExpires
accountNameHistory
aCSPolicyName
adminCount
adminDescription
adminDisplayName
allowedAttributes
allowedAttributesEffective
allowedChildClasses
allowedChildClassesEffective
altSecurityIdentities
assistant
attributeCertificateAttribute
audio
badPasswordTime
badPwdCount
bridgeheadServerListBL
businessCategory
c
canonicalName
carLicense
cn
co
codePage
comment
company
controlAccessRights
countryCode
createTimeStamp
dBCSPwd
defaultClassStore
department
departmentNumber
description
desktopProfile
destinationIndicator
directReports
displayName
displayNamePrintable
distinguishedName
division
dSASignature
dSCorePropagationData
dynamicLDAPServer
employeeID
employeeNumber
employeeType
extensionName
facsimileTelephoneNumber
flags
fromEntry
frsComputerReferenceBL
fRSMemberReferenceBL
fSMORoleOwner
garbageCollPeriod
gecos
generationQualifier
gidNumber
givenName
groupMembershipSAM
groupPriority
groupsToIgnore
homeDirectory
homeDrive
homePhone
homePostalAddress
houseIdentifier
info
initials
instanceType
internationalISDNNumber
ipPhone
isCriticalSystemObject
isDeleted
isPrivilegeHolder
isRecycled
jpegPhoto
l
labeledURI
lastKnownParent
lastLogoff
lastLogon
lastLogonTimestamp
legacyExchangeDN
lmPwdHistory
localeID
lockoutTime
loginShell
logonCount
logonHours
logonWorkstation
mail
managedObjects
manager
masteredBy
maxStorage
memberOf
mhsORAddress
middleName
mobile
modifyTimeStamp
mS-DS-ConsistencyChildCount
mS-DS-ConsistencyGuid
mS-DS-CreatorSID
msCOM-PartitionSetLink
msCOM-UserLink
msCOM-UserPartitionSetLink
msDFSR-ComputerReferenceBL
msDFSR-MemberReferenceBL
msDRM-IdentityCertificate
msDS-AllowedToActOnBehalfOfOtherIdentity
msDS-AllowedToDelegateTo
msDS-Approx-Immed-Subordinates
msDS-AssignedAuthNPolicy
msDS-AssignedAuthNPolicySilo
msDS-AuthenticatedAtDC
msDS-AuthenticatedToAccountlist
msDS-AuthNPolicySiloMembersBL
msDS-Cached-Membership
msDS-Cached-Membership-Time-Stamp
msDS-ClaimSharesPossibleValuesWithBL
msDS-CloudAnchor
msDS-cloudExtensionAttribute1
msDS-cloudExtensionAttribute10
msDS-cloudExtensionAttribute11
msDS-cloudExtensionAttribute12
msDS-cloudExtensionAttribute13
msDS-cloudExtensionAttribute14
msDS-cloudExtensionAttribute15
msDS-cloudExtensionAttribute16
msDS-cloudExtensionAttribute17
msDS-cloudExtensionAttribute18
msDS-cloudExtensionAttribute19
msDS-cloudExtensionAttribute2
msDS-cloudExtensionAttribute20
msDS-cloudExtensionAttribute3
msDS-cloudExtensionAttribute4
msDS-cloudExtensionAttribute5
msDS-cloudExtensionAttribute6
msDS-cloudExtensionAttribute7
msDS-cloudExtensionAttribute8
msDS-cloudExtensionAttribute9
msDS-EnabledFeatureBL
msDS-ExternalDirectoryObjectId
msDS-FailedInteractiveLogonCount
msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon
msDS-GeoCoordinatesAltitude
msDS-GeoCoordinatesLatitude
msDS-GeoCoordinatesLongitude
msDS-HABSeniorityIndex
msDS-HostServiceAccountBL
msDS-IsDomainFor
msDS-IsFullReplicaFor
msDS-IsPartialReplicaFor
msDS-IsPrimaryComputerFor
msDS-KeyCredentialLink
msDS-KeyPrincipalBL
msDS-KeyVersionNumber
msDS-KrbTgtLinkBl
msDS-LastFailedInteractiveLogonTime
msDS-LastKnownRDN
msDS-LastSuccessfulInteractiveLogonTime
msDS-LocalEffectiveDeletionTime
msDS-LocalEffectiveRecycleTime
msDs-masteredBy
msds-memberOfTransitive
msDS-MembersForAzRoleBL
msDS-MembersOfResourcePropertyListBL
msds-memberTransitive
msDS-NC-RO-Replica-Locations-BL
msDS-NCReplCursors
msDS-NCReplInboundNeighbors
msDS-NCReplOutboundNeighbors
msDS-NcType
msDS-NonMembersBL
msDS-ObjectReferenceBL
msDS-ObjectSoa
msDS-OIDToGroupLinkBl
msDS-OperationsForAzRoleBL
msDS-OperationsForAzTaskBL
msDS-parentdistname
msDS-PhoneticCompanyName
msDS-PhoneticDepartment
msDS-PhoneticDisplayName
msDS-PhoneticFirstName
msDS-PhoneticLastName
msDS-preferredDataLocation
msDS-PrimaryComputer
msDS-PrincipalName
msDS-PSOApplied
msDS-ReplAttributeMetaData
msDS-ReplValueMetaData
msDS-ReplValueMetaDataExt
msDS-ResultantPSO
msDS-RevealedDSAs
msDS-RevealedListBL
msDS-SecondaryKrbTgtNumber
msDS-Site-Affinity
msDS-SourceAnchor
msDS-SourceObjectDN
msDS-SupportedEncryptionTypes
msDS-SyncServerUrl
msDS-TasksForAzRoleBL
msDS-TasksForAzTaskBL
msDS-TDOEgressBL
msDS-TDOIngressBL
msds-tokenGroupNames
msds-tokenGroupNamesGlobalAndUniversal
msds-tokenGroupNamesNoGCAcceptable
msDS-User-Account-Control-Computed
msDS-UserPasswordExpiryTimeComputed
msDS-ValueTypeReferenceBL
msExchAssistantName
msExchHouseIdentifier
msExchLabeledURI
msIIS-FTPDir
msIIS-FTPRoot
mSMQDigests
mSMQDigestsMig
mSMQSignCertificates
mSMQSignCertificatesMig
msNPAllowDialin
msNPCallingStationID
msNPSavedCallingStationID
msPKI-CredentialRoamingTokens
msPKIAccountCredentials
msPKIDPAPIMasterKeys
msPKIRoamingTimeStamp
msRADIUS-FramedInterfaceId
msRADIUS-FramedIpv6Prefix
msRADIUS-FramedIpv6Route
msRADIUS-SavedFramedInterfaceId
msRADIUS-SavedFramedIpv6Prefix
msRADIUS-SavedFramedIpv6Route
msRADIUSCallbackNumber
msRADIUSFramedIPAddress
msRADIUSFramedRoute
msRADIUSServiceType
msRASSavedCallbackNumber
msRASSavedFramedIPAddress
msRASSavedFramedRoute
msSFU30Name
msSFU30NisDomain
msSFU30PosixMemberOf
msTSAllowLogon
msTSBrokenConnectionAction
msTSConnectClientDrives
msTSConnectPrinterDrives
msTSDefaultToMainPrinter
msTSExpireDate
msTSExpireDate2
msTSExpireDate3
msTSExpireDate4
msTSHomeDirectory
msTSHomeDrive
msTSInitialProgram
msTSLicenseVersion
msTSLicenseVersion2
msTSLicenseVersion3
msTSLicenseVersion4
msTSLSProperty01
msTSLSProperty02
msTSManagingLS
msTSManagingLS2
msTSManagingLS3
msTSManagingLS4
msTSMaxConnectionTime
msTSMaxDisconnectionTime
msTSMaxIdleTime
msTSPrimaryDesktop
msTSProfilePath
msTSProperty01
msTSProperty02
msTSReconnectionAction
msTSRemoteControl
msTSSecondaryDesktops
msTSWorkDirectory
name
netbootSCPBL
networkAddress
nonSecurityMemberBL
ntPwdHistory
nTSecurityDescriptor
o
objectCategory
objectClass
objectGUID
objectSid
objectVersion
operatorCount
otherFacsimileTelephoneNumber
otherHomePhone
otherIpPhone
otherLoginWorkstations
otherMailbox
otherMobile
otherPager
otherTelephone
otherWellKnownObjects
ou
ownerBL
pager
partialAttributeDeletionList
partialAttributeSet
personalTitle
photo
physicalDeliveryOfficeName
possibleInferiors
postalAddress
postalCode
postOfficeBox
preferredDeliveryMethod
preferredLanguage
preferredOU
primaryGroupID
primaryInternationalISDNNumber
primaryTelexNumber
profilePath
proxiedObjectName
proxyAddresses
pwdLastSet
queryPolicyBL
registeredAddress
replPropertyMetaData
replUpToDateVector
repsFrom
repsTo
revision
rid
roomNumber
sAMAccountName
sAMAccountType
scriptPath
sDRightsEffective
secretary
securityIdentifier
seeAlso
serialNumber
serverReferenceBL
servicePrincipalName
shadowExpire
shadowFlag
shadowInactive
shadowLastChange
shadowMax
shadowMin
shadowWarning
showInAddressBook
showInAdvancedViewOnly
sIDHistory
siteObjectBL
sn
st
street
streetAddress
structuralObjectClass
subRefs
subSchemaSubEntry
supplementalCredentials
systemFlags
telephoneNumber
teletexTerminalIdentifier
telexNumber
terminalServer
textEncodedORAddress
thumbnailLogo
thumbnailPhoto
title
tokenGroups
tokenGroupsGlobalAndUniversal
tokenGroupsNoGCAcceptable
uid
uidNumber
unicodePwd
unixHomeDirectory
unixUserPassword
url
userAccountControl
userCert
userCertificate
userParameters
userPassword
userPKCS12
userPrincipalName
userSharedFolder
userSharedFolderOther
userSMIMECertificate
userWorkstations
uSNChanged
uSNCreated
uSNDSALastObjRemoved
USNIntersite
uSNLastObjRem
uSNSource
wbemPath
wellKnownObjects
whenChanged
whenCreated
wWWHomePage
x121Address
x500uniqueIdentifier


$sam = "canary"
$container = "OU=perf,DC=megacorp,DC=local"
$dn = "CN=$sam,$container"

# Define the list of attribute names
$attributeNames = @(
    "givenName",
    "accountNameHistory",
    "aCSPolicyName",
    "adminDescription",
    "adminDisplayName"
)

# Initialize an empty hash table to store the attribute-value pairs
$attributes = @{}

# Iterate over the list of attribute names to populate the hash table with computed values
foreach ($attributeName in $attributeNames) {
    $attributeValue = $attributeName + "a"
    $attributes[$attributeName] = $attributeValue
}

# Iterate over the hash table and set each attribute one by one
foreach ($attribute in $attributes.GetEnumerator()) {
    $attributeName = $attribute.Key
    $attributeValue = $attribute.Value

    Write-Host "Setting $attributeName to $attributeValue"
    Set-ADObject -Identity $dn -Replace @{$attributeName = $attributeValue}
}




# Old set-adobject 
set-adobject -Identity $dn -replace @{accountNameHistory="accountNameHistory" + "a"}
set-adobject -Identity $dn -replace @{aCSPolicyName="aCSPolicyName"}
set-adobject -Identity $dn -replace @{adminDescription="adminDescription"}
set-adobject -Identity $dn -replace @{adminDisplayName="adminDisplayName"}
set-adobject -Identity $dn -replace @{attributeCertificateAttribute="attributeCertificateAttribute"}
set-adobject -Identity $dn -replace @{audio="audio"}
set-adobject -Identity $dn -replace @{businessCategory="businessCategory"}
set-adobject -Identity $dn -replace @{c="c"}
set-adobject -Identity $dn -replace @{carLicense="carLicense"}
set-adobject -Identity $dn -replace @{co="co"}
set-adobject -Identity $dn -replace @{comment="comment"}
set-adobject -Identity $dn -replace @{company="company"}
set-adobject -Identity $dn -replace @{department="department"}
set-adobject -Identity $dn -replace @{departmentNumber="departmentNumber"}
set-adobject -Identity $dn -replace @{description="description"}
set-adobject -Identity $dn -replace @{desktopProfile="desktopProfile"}
set-adobject -Identity $dn -replace @{destinationIndicator="destinationIndicator"}
set-adobject -Identity $dn -replace @{displayName="displayName"}
set-adobject -Identity $dn -replace @{displayNamePrintable="displayNamePrintable"}
set-adobject -Identity $dn -replace @{division="division"}
set-adobject -Identity $dn -replace @{employeeID="employeeID"}
set-adobject -Identity $dn -replace @{employeeNumber="employeeNumber"}
set-adobject -Identity $dn -replace @{employeeType="employeeType"}
set-adobject -Identity $dn -replace @{extensionName="extensionName"}
set-adobject -Identity $dn -replace @{facsimileTelephoneNumber="facsimileTelephoneNumber"}
set-adobject -Identity $dn -replace @{generationQualifier="generationQualifier"}
set-adobject -Identity $dn -replace @{givenName="givenName"}
set-adobject -Identity $dn -replace @{groupMembershipSAM="groupMembershipSAM"}
set-adobject -Identity $dn -replace @{groupPriority="groupPriority"}
set-adobject -Identity $dn -replace @{groupsToIgnore="groupsToIgnore"}
set-adobject -Identity $dn -replace @{homeDirectory="homeDirectory"}
set-adobject -Identity $dn -replace @{homeDrive="homeDrive"}
set-adobject -Identity $dn -replace @{homePhone="homePhone"}
set-adobject -Identity $dn -replace @{homePostalAddress="homePostalAddress"}
set-adobject -Identity $dn -replace @{houseIdentifier="houseIdentifier"}
set-adobject -Identity $dn -replace @{info="info"}
set-adobject -Identity $dn -replace @{ipPhone="ipPhone"}
set-adobject -Identity $dn -replace @{jpegPhoto="jpegPhoto"}
set-adobject -Identity $dn -replace @{l="l"}
set-adobject -Identity $dn -replace @{labeledURI="labeledURI"}
set-adobject -Identity $dn -replace @{logonWorkstation="logonWorkstation"}
set-adobject -Identity $dn -replace @{mail="mail"}
set-adobject -Identity $dn -replace @{mhsORAddress="mhsORAddress"}
set-adobject -Identity $dn -replace @{middleName="middleName"}
set-adobject -Identity $dn -replace @{mobile="mobile"}
set-adobject -Identity $dn -replace @{"mS-DS-ConsistencyGuid"="mS-DS-ConsistencyGuid"}
set-adobject -Identity $dn -replace @{"msDRM-IdentityCertificate"="msDRM-IdentityCertificate"}
set-adobject -Identity $dn -replace @{"msDS-ExternalDirectoryObjectId"="msDS-ExternalDirectoryObjectId"}
set-adobject -Identity $dn -replace @{"msDS-PhoneticCompanyName"="msDS-PhoneticCompanyName"}
set-adobject -Identity $dn -replace @{"msDS-PhoneticDepartment"="msDS-PhoneticDepartment"}
set-adobject -Identity $dn -replace @{"msDS-PhoneticDisplayName"="msDS-PhoneticDisplayName"}
set-adobject -Identity $dn -replace @{"msDS-PhoneticFirstName"="msDS-PhoneticFirstName"}
set-adobject -Identity $dn -replace @{"msDS-PhoneticLastName"="msDS-PhoneticLastName"}
set-adobject -Identity $dn -replace @{"msDS-SourceAnchor"="msDS-SourceAnchor"}
set-adobject -Identity $dn -replace @{"msDS-SourceObjectDN"="msDS-SourceObjectDN"}
set-adobject -Identity $dn -replace @{"msDS-SyncServerUrl"="msDS-SyncServerUrl"}
set-adobject -Identity $dn -replace @{msExchAssistantName="msExchAssistantName"}
set-adobject -Identity $dn -replace @{msExchHouseIdentifier="msExchHouseIdentifier"}
set-adobject -Identity $dn -replace @{msExchLabeledURI="msExchLabeledURI"}
set-adobject -Identity $dn -replace @{"msIIS-FTPDir"="msIIS-FTPDir"}
set-adobject -Identity $dn -replace @{"msIIS-FTPRoot"="msIIS-FTPRoot"}
set-adobject -Identity $dn -replace @{mSMQSignCertificates="mSMQSignCertificates"}
set-adobject -Identity $dn -replace @{mSMQSignCertificatesMig="mSMQSignCertificatesMig"}
set-adobject -Identity $dn -replace @{msNPCallingStationID="msNPCallingStationID"}
set-adobject -Identity $dn -replace @{msNPSavedCallingStationID="msNPSavedCallingStationID"}
set-adobject -Identity $dn -replace @{msPKIRoamingTimeStamp="msPKIRoamingTimeStamp"}
set-adobject -Identity $dn -replace @{"msRADIUS-FramedIpv6Route"="msRADIUS-FramedIpv6Route"}
set-adobject -Identity $dn -replace @{"msRADIUS-SavedFramedIpv6Route"="msRADIUS-SavedFramedIpv6Route"}
set-adobject -Identity $dn -replace @{msRADIUSCallbackNumber="msRADIUSCallbackNumber"}
set-adobject -Identity $dn -replace @{msRADIUSFramedRoute="msRADIUSFramedRoute"}
set-adobject -Identity $dn -replace @{msRASSavedCallbackNumber="msRASSavedCallbackNumber"}
set-adobject -Identity $dn -replace @{msRASSavedFramedRoute="msRASSavedFramedRoute"}
set-adobject -Identity $dn -replace @{msSFU30Name="msSFU30Name"}
set-adobject -Identity $dn -replace @{msSFU30NisDomain="msSFU30NisDomain"}
set-adobject -Identity $dn -replace @{msTSHomeDirectory="msTSHomeDirectory"}
set-adobject -Identity $dn -replace @{msTSHomeDrive="msTSHomeDrive"}
set-adobject -Identity $dn -replace @{msTSInitialProgram="msTSInitialProgram"}
set-adobject -Identity $dn -replace @{msTSLicenseVersion="msTSLicenseVersion"}
set-adobject -Identity $dn -replace @{msTSLicenseVersion2="msTSLicenseVersion2"}
set-adobject -Identity $dn -replace @{msTSLicenseVersion3="msTSLicenseVersion3"}
set-adobject -Identity $dn -replace @{msTSLicenseVersion4="msTSLicenseVersion4"}
set-adobject -Identity $dn -replace @{msTSLSProperty01="msTSLSProperty01"}
set-adobject -Identity $dn -replace @{msTSLSProperty02="msTSLSProperty02"}
set-adobject -Identity $dn -replace @{msTSManagingLS="msTSManagingLS"}
set-adobject -Identity $dn -replace @{msTSManagingLS2="msTSManagingLS2"}
set-adobject -Identity $dn -replace @{msTSManagingLS3="msTSManagingLS3"}
set-adobject -Identity $dn -replace @{msTSManagingLS4="msTSManagingLS4"}
set-adobject -Identity $dn -replace @{msTSProfilePath="msTSProfilePath"}
set-adobject -Identity $dn -replace @{msTSProperty01="msTSProperty01"}
set-adobject -Identity $dn -replace @{msTSProperty02="msTSProperty02"}
set-adobject -Identity $dn -replace @{msTSWorkDirectory="msTSWorkDirectory"}
set-adobject -Identity $dn -replace @{networkAddress="networkAddress"}
set-adobject -Identity $dn -replace @{otherFacsimileTelephoneNumber="otherFacsimileTelephoneNumber"}
set-adobject -Identity $dn -replace @{otherHomePhone="otherHomePhone"}
set-adobject -Identity $dn -replace @{otherIpPhone="otherIpPhone"}
set-adobject -Identity $dn -replace @{otherLoginWorkstations="otherLoginWorkstations"}
set-adobject -Identity $dn -replace @{otherMailbox="otherMailbox"}
set-adobject -Identity $dn -replace @{otherMobile="otherMobile"}
set-adobject -Identity $dn -replace @{otherPager="otherPager"}
set-adobject -Identity $dn -replace @{otherTelephone="otherTelephone"}
set-adobject -Identity $dn -replace @{ou="ou"}
set-adobject -Identity $dn -replace @{pager="pager"}
set-adobject -Identity $dn -replace @{personalTitle="personalTitle"}
set-adobject -Identity $dn -replace @{photo="photo"}
set-adobject -Identity $dn -replace @{physicalDeliveryOfficeName="physicalDeliveryOfficeName"}
set-adobject -Identity $dn -replace @{postalAddress="postalAddress"}
set-adobject -Identity $dn -replace @{postalCode="postalCode"}
set-adobject -Identity $dn -replace @{postOfficeBox="postOfficeBox"}
set-adobject -Identity $dn -replace @{preferredLanguage="preferredLanguage"}
set-adobject -Identity $dn -replace @{primaryInternationalISDNNumber="primaryInternationalISDNNumber"}
set-adobject -Identity $dn -replace @{primaryTelexNumber="primaryTelexNumber"}
set-adobject -Identity $dn -replace @{profilePath="profilePath"}
set-adobject -Identity $dn -replace @{proxyAddresses="proxyAddresses"}
set-adobject -Identity $dn -replace @{registeredAddress="registeredAddress"}
set-adobject -Identity $dn -replace @{scriptPath="scriptPath"}
set-adobject -Identity $dn -replace @{serialNumber="serialNumber"}
set-adobject -Identity $dn -replace @{sn="sn"}
set-adobject -Identity $dn -replace @{st="st"}
set-adobject -Identity $dn -replace @{street="street"}
set-adobject -Identity $dn -replace @{streetAddress="streetAddress"}
set-adobject -Identity $dn -replace @{telephoneNumber="telephoneNumber"}
set-adobject -Identity $dn -replace @{teletexTerminalIdentifier="teletexTerminalIdentifier"}
set-adobject -Identity $dn -replace @{telexNumber="telexNumber"}
set-adobject -Identity $dn -replace @{terminalServer="terminalServer"}
set-adobject -Identity $dn -replace @{textEncodedORAddress="textEncodedORAddress"}
set-adobject -Identity $dn -replace @{thumbnailLogo="thumbnailLogo"}
set-adobject -Identity $dn -replace @{thumbnailPhoto="thumbnailPhoto"}
set-adobject -Identity $dn -replace @{title="title"}
set-adobject -Identity $dn -replace @{uid="uid"}
set-adobject -Identity $dn -replace @{unixHomeDirectory="unixHomeDirectory"}
set-adobject -Identity $dn -replace @{unixUserPassword="unixUserPassword"}
set-adobject -Identity $dn -replace @{url="url"}
set-adobject -Identity $dn -replace @{userCert="userCert"}
set-adobject -Identity $dn -replace @{userCertificate="userCertificate"}
set-adobject -Identity $dn -replace @{userParameters="userParameters"}
set-adobject -Identity $dn -replace @{userPassword="userPassword"}
set-adobject -Identity $dn -replace @{userPKCS12="userPKCS12"}
set-adobject -Identity $dn -replace @{userPrincipalName="userPrincipalName"}
set-adobject -Identity $dn -replace @{userSharedFolder="userSharedFolder"}
set-adobject -Identity $dn -replace @{userSharedFolderOther="userSharedFolderOther"}
set-adobject -Identity $dn -replace @{userSMIMECertificate="userSMIMECertificate"}
set-adobject -Identity $dn -replace @{userWorkstations="userWorkstations"}
set-adobject -Identity $dn -replace @{wbemPath="wbemPath"}
set-adobject -Identity $dn -replace @{wWWHomePage="wWWHomePage"}
set-adobject -Identity $dn -replace @{x121Address="x121Address"}
set-adobject -Identity $dn -replace @{x500uniqueIdentifier="x500uniqueIdentifier"}









#>