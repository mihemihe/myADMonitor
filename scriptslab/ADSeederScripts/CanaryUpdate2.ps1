# I want to create a script to modify an AD account with sAMAccountName "canary"
# I am enumerating all the properties possible for the class user
# The properties will be modified one by one not with an collection of properties
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{givenName="NewFirstName"}

# accountExpires

#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{accountExpires="accountExpires"} 
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{accountNameHistory="accountNameHistory"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{aCSPolicyName="aCSPolicyName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{adminCount="adminCount"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{adminDescription="adminDescription"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{adminDisplayName="adminDisplayName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{allowedAttributes="allowedAttributes"} #
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{allowedAttributesEffective="allowedAttributesEffective"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{allowedChildClasses="allowedChildClasses"} #
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{allowedChildClassesEffective="allowedChildClassesEffective"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{altSecurityIdentities="altSecurityIdentities"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{assistant="assistant"} DN
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{attributeCertificateAttribute="attributeCertificateAttribute"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{audio="audio"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{badPasswordTime="badPasswordTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{badPwdCount="badPwdCount"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{bridgeheadServerListBL="bridgeheadServerListBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{businessCategory="businessCategory"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{c="c"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{canonicalName="canonicalName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{carLicense="carLicense"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{cn="cn"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{co="co"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{codePage="codePage"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{comment="comment"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{company="company"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{controlAccessRights="controlAccessRights"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{countryCode="countryCode"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{createTimeStamp="createTimeStamp"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{dBCSPwd="dBCSPwd"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{defaultClassStore="defaultClassStore"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{department="department"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{departmentNumber="departmentNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{description="description"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{desktopProfile="desktopProfile"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{destinationIndicator="destinationIndicator"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{directReports="directReports"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{displayName="displayName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{displayNamePrintable="displayNamePrintable"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{distinguishedName="distinguishedName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{division="division"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{dSASignature="dSASignature"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{dSCorePropagationData="dSCorePropagationData"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{dynamicLDAPServer="dynamicLDAPServer"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{employeeID="employeeID"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{employeeNumber="employeeNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{employeeType="employeeType"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{extensionName="extensionName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{facsimileTelephoneNumber="facsimileTelephoneNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{flags="flags"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{fromEntry="fromEntry"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{frsComputerReferenceBL="frsComputerReferenceBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{fRSMemberReferenceBL="fRSMemberReferenceBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{fSMORoleOwner="fSMORoleOwner"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{garbageCollPeriod="garbageCollPeriod"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{gecos="gecos"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{generationQualifier="generationQualifier"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{gidNumber="gidNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{givenName="givenName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{groupMembershipSAM="groupMembershipSAM"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{groupPriority="groupPriority"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{groupsToIgnore="groupsToIgnore"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{homeDirectory="homeDirectory"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{homeDrive="homeDrive"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{homePhone="homePhone"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{homePostalAddress="homePostalAddress"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{houseIdentifier="houseIdentifier"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{info="info"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{initials="initials"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{instanceType="instanceType"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{internationalISDNNumber="internationalISDNNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{ipPhone="ipPhone"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{isCriticalSystemObject="isCriticalSystemObject"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{isDeleted="isDeleted"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{isPrivilegeHolder="isPrivilegeHolder"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{isRecycled="isRecycled"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{jpegPhoto="jpegPhoto"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{l="l"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{labeledURI="labeledURI"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{lastKnownParent="lastKnownParent"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{lastLogoff="lastLogoff"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{lastLogon="lastLogon"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{lastLogonTimestamp="lastLogonTimestamp"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{legacyExchangeDN="legacyExchangeDN"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{lmPwdHistory="lmPwdHistory"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{localeID="localeID"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{lockoutTime="lockoutTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{loginShell="loginShell"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{logonCount="logonCount"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{logonHours="logonHours"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{logonWorkstation="logonWorkstation"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mail="mail"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{managedObjects="managedObjects"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{manager="manager"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{masteredBy="masteredBy"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{maxStorage="maxStorage"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{memberOf="memberOf"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mhsORAddress="mhsORAddress"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{middleName="middleName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mobile="mobile"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{modifyTimeStamp="modifyTimeStamp"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"mS-DS-ConsistencyChildCount"="mS-DS-ConsistencyChildCount"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"mS-DS-ConsistencyGuid"="mS-DS-ConsistencyGuid"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"mS-DS-CreatorSID"="mS-DS-CreatorSID"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msCOM-PartitionSetLink"="msCOM-PartitionSetLink"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msCOM-UserLink"="msCOM-UserLink"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msCOM-UserPartitionSetLink"="msCOM-UserPartitionSetLink"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDFSR-ComputerReferenceBL"="msDFSR-ComputerReferenceBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDFSR-MemberReferenceBL"="msDFSR-MemberReferenceBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDRM-IdentityCertificate"="msDRM-IdentityCertificate"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AllowedToActOnBehalfOfOtherIdentity"="msDS-AllowedToActOnBehalfOfOtherIdentity"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AllowedToDelegateTo"="msDS-AllowedToDelegateTo"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-Approx-Immed-Subordinates"="msDS-Approx-Immed-Subordinates"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AssignedAuthNPolicy"="msDS-AssignedAuthNPolicy"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AssignedAuthNPolicySilo"="msDS-AssignedAuthNPolicySilo"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AuthenticatedAtDC"="msDS-AuthenticatedAtDC"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AuthenticatedToAccountlist"="msDS-AuthenticatedToAccountlist"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-AuthNPolicySiloMembersBL"="msDS-AuthNPolicySiloMembersBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-Cached-Membership"="msDS-Cached-Membership"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-Cached-Membership-Time-Stamp"="msDS-Cached-Membership-Time-Stamp"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ClaimSharesPossibleValuesWithB"="msDS-ClaimSharesPossibleValuesWithBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-CloudAnchor"="msDS-CloudAnchor"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute1"="msDS-cloudExtensionAttribute1"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute10"="msDS-cloudExtensionAttribute10"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute11"="msDS-cloudExtensionAttribute11"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute12"="msDS-cloudExtensionAttribute12"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute13"="msDS-cloudExtensionAttribute13"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute14"="msDS-cloudExtensionAttribute14"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute15"="msDS-cloudExtensionAttribute15"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute16"="msDS-cloudExtensionAttribute16"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute17"="msDS-cloudExtensionAttribute17"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute18"="msDS-cloudExtensionAttribute18"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute19"="msDS-cloudExtensionAttribute19"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute2"="msDS-cloudExtensionAttribute2"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute20"="msDS-cloudExtensionAttribute20"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute3"="msDS-cloudExtensionAttribute3"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute4"="msDS-cloudExtensionAttribute4"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute5"="msDS-cloudExtensionAttribute5"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute6"="msDS-cloudExtensionAttribute6"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute7"="msDS-cloudExtensionAttribute7"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute8"="msDS-cloudExtensionAttribute8"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-cloudExtensionAttribute9"="msDS-cloudExtensionAttribute9"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-EnabledFeatureBL"="msDS-EnabledFeatureBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ExternalDirectoryObjectId"="msDS-ExternalDirectoryObjectId"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-FailedInteractiveLogonCount"="msDS-FailedInteractiveLogonCount"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon"="msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-GeoCoordinatesAltitude"="msDS-GeoCoordinatesAltitude"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-GeoCoordinatesLatitude"="msDS-GeoCoordinatesLatitude"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-GeoCoordinatesLongitude"="msDS-GeoCoordinatesLongitude"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-HABSeniorityIndex"="msDS-HABSeniorityIndex"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-HostServiceAccountBL"="msDS-HostServiceAccountBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-IsDomainFor"="msDS-IsDomainFor"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-IsFullReplicaFor"="msDS-IsFullReplicaFor"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-IsPartialReplicaFor"="msDS-IsPartialReplicaFor"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-IsPrimaryComputerFor"="msDS-IsPrimaryComputerFor"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-KeyCredentialLink"="msDS-KeyCredentialLink"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-KeyPrincipalBL"="msDS-KeyPrincipalBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-KeyVersionNumber"="msDS-KeyVersionNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-KrbTgtLinkBl"="msDS-KrbTgtLinkBl"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-LastFailedInteractiveLogonTime"="msDS-LastFailedInteractiveLogonTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-LastKnownRDN"="msDS-LastKnownRDN"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-LastSuccessfulInteractiveLogonTime"="msDS-LastSuccessfulInteractiveLogonTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-LocalEffectiveDeletionTime"="msDS-LocalEffectiveDeletionTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-LocalEffectiveRecycleTime"="msDS-LocalEffectiveRecycleTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDs-masteredBy"="msDs-masteredBy"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msds-memberOfTransitive"="msds-memberOfTransitive"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-MembersForAzRoleBL"="msDS-MembersForAzRoleBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-MembersOfResourcePropertyListBL"="msDS-MembersOfResourcePropertyListBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msds-memberTransitive"="msds-memberTransitive"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-NC-RO-Replica-Locations-BL"="msDS-NC-RO-Replica-Locations-BL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-NCReplCursors"="msDS-NCReplCursors"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-NCReplInboundNeighbors"="msDS-NCReplInboundNeighbors"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-NCReplOutboundNeighbors"="msDS-NCReplOutboundNeighbors"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-NcType"="msDS-NcType"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-NonMembersBL"="msDS-NonMembersBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ObjectReferenceBL"="msDS-ObjectReferenceBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ObjectSoa"="msDS-ObjectSoa"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-OIDToGroupLinkBl"="msDS-OIDToGroupLinkBl"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-OperationsForAzRoleBL"="msDS-OperationsForAzRoleBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-OperationsForAzTaskBL"="msDS-OperationsForAzTaskBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-parentdistname"="msDS-parentdistname"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PhoneticCompanyName"="msDS-PhoneticCompanyName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PhoneticDepartment"="msDS-PhoneticDepartment"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PhoneticDisplayName"="msDS-PhoneticDisplayName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PhoneticFirstName"="msDS-PhoneticFirstName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PhoneticLastName"="msDS-PhoneticLastName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-preferredDataLocation"="msDS-preferredDataLocation"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PrimaryComputer"="msDS-PrimaryComputer"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PrincipalName"="msDS-PrincipalName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-PSOApplied"="msDS-PSOApplied"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ReplAttributeMetaData"="msDS-ReplAttributeMetaData"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ReplValueMetaData"="msDS-ReplValueMetaData"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ReplValueMetaDataExt"="msDS-ReplValueMetaDataExt"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ResultantPSO"="msDS-ResultantPSO"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-RevealedDSAs"="msDS-RevealedDSAs"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-RevealedListBL"="msDS-RevealedListBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-SecondaryKrbTgtNumber"="msDS-SecondaryKrbTgtNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-Site-Affinity"="msDS-Site-Affinity"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-SourceAnchor"="msDS-SourceAnchor"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-SourceObjectDN"="msDS-SourceObjectDN"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-SupportedEncryptionTypes"="msDS-SupportedEncryptionTypes"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-SyncServerUrl"="msDS-SyncServerUrl"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-TasksForAzRoleBL"="msDS-TasksForAzRoleBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-TasksForAzTaskBL"="msDS-TasksForAzTaskBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-TDOEgressBL"="msDS-TDOEgressBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-TDOIngressBL"="msDS-TDOIngressBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msds-tokenGroupNames"="msds-tokenGroupNames"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msds-tokenGroupNamesGlobalAndUniversal"="msds-tokenGroupNamesGlobalAndUniversal"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msds-tokenGroupNamesNoGCAcceptable"="msds-tokenGroupNamesNoGCAcceptable"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-User-Account-Control-Computed"="msDS-User-Account-Control-Computed"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-UserPasswordExpiryTimeComputed"="msDS-UserPasswordExpiryTimeComputed"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msDS-ValueTypeReferenceBL"="msDS-ValueTypeReferenceBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msExchAssistantName="msExchAssistantName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msExchHouseIdentifier="msExchHouseIdentifier"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msExchLabeledURI="msExchLabeledURI"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msIIS-FTPDir"="msIIS-FTPDir"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msIIS-FTPRoot"="msIIS-FTPRoot"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mSMQDigests="mSMQDigests"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mSMQDigestsMig="mSMQDigestsMig"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mSMQSignCertificates="mSMQSignCertificates"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{mSMQSignCertificatesMig="mSMQSignCertificatesMig"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msNPAllowDialin="msNPAllowDialin"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msNPCallingStationID="msNPCallingStationID"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msNPSavedCallingStationID="msNPSavedCallingStationID"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msPKI-CredentialRoamingTokens"="msPKI-CredentialRoamingTokens"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msPKIAccountCredentials="msPKIAccountCredentials"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msPKIDPAPIMasterKeys="msPKIDPAPIMasterKeys"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msPKIRoamingTimeStamp="msPKIRoamingTimeStamp"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msRADIUS-FramedInterfaceId"="msRADIUS-FramedInterfaceId"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msRADIUS-FramedIpv6Prefix"="msRADIUS-FramedIpv6Prefix"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msRADIUS-FramedIpv6Route"="msRADIUS-FramedIpv6Route"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msRADIUS-SavedFramedInterfaceId"="msRADIUS-SavedFramedInterfaceId"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msRADIUS-SavedFramedIpv6Prefix"="msRADIUS-SavedFramedIpv6Prefix"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{"msRADIUS-SavedFramedIpv6Route"="msRADIUS-SavedFramedIpv6Route"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRADIUSCallbackNumber="msRADIUSCallbackNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRADIUSFramedIPAddress="msRADIUSFramedIPAddress"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRADIUSFramedRoute="msRADIUSFramedRoute"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRADIUSServiceType="msRADIUSServiceType"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRASSavedCallbackNumber="msRASSavedCallbackNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRASSavedFramedIPAddress="msRASSavedFramedIPAddress"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msRASSavedFramedRoute="msRASSavedFramedRoute"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msSFU30Name="msSFU30Name"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msSFU30NisDomain="msSFU30NisDomain"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msSFU30PosixMemberOf="msSFU30PosixMemberOf"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSAllowLogon="msTSAllowLogon"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSBrokenConnectionAction="msTSBrokenConnectionAction"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSConnectClientDrives="msTSConnectClientDrives"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSConnectPrinterDrives="msTSConnectPrinterDrives"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSDefaultToMainPrinter="msTSDefaultToMainPrinter"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSExpireDate="msTSExpireDate"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSExpireDate2="msTSExpireDate2"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSExpireDate3="msTSExpireDate3"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSExpireDate4="msTSExpireDate4"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSHomeDirectory="msTSHomeDirectory"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSHomeDrive="msTSHomeDrive"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSInitialProgram="msTSInitialProgram"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSLicenseVersion="msTSLicenseVersion"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSLicenseVersion2="msTSLicenseVersion2"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSLicenseVersion3="msTSLicenseVersion3"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSLicenseVersion4="msTSLicenseVersion4"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSLSProperty01="msTSLSProperty01"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSLSProperty02="msTSLSProperty02"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSManagingLS="msTSManagingLS"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSManagingLS2="msTSManagingLS2"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSManagingLS3="msTSManagingLS3"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSManagingLS4="msTSManagingLS4"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSMaxConnectionTime="msTSMaxConnectionTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSMaxDisconnectionTime="msTSMaxDisconnectionTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSMaxIdleTime="msTSMaxIdleTime"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSPrimaryDesktop="msTSPrimaryDesktop"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSProfilePath="msTSProfilePath"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSProperty01="msTSProperty01"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSProperty02="msTSProperty02"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSReconnectionAction="msTSReconnectionAction"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSRemoteControl="msTSRemoteControl"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSSecondaryDesktops="msTSSecondaryDesktops"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{msTSWorkDirectory="msTSWorkDirectory"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{name="name"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{netbootSCPBL="netbootSCPBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{networkAddress="networkAddress"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{nonSecurityMemberBL="nonSecurityMemberBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{ntPwdHistory="ntPwdHistory"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{nTSecurityDescriptor="nTSecurityDescriptor"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{o="o"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{objectCategory="objectCategory"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{objectClass="objectClass"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{objectGUID="objectGUID"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{objectSid="objectSid"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{objectVersion="objectVersion"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{operatorCount="operatorCount"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherFacsimileTelephoneNumber="otherFacsimileTelephoneNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherHomePhone="otherHomePhone"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherIpPhone="otherIpPhone"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherLoginWorkstations="otherLoginWorkstations"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherMailbox="otherMailbox"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherMobile="otherMobile"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherPager="otherPager"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherTelephone="otherTelephone"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{otherWellKnownObjects="otherWellKnownObjects"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{ou="ou"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{ownerBL="ownerBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{pager="pager"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{partialAttributeDeletionList="partialAttributeDeletionList"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{partialAttributeSet="partialAttributeSet"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{personalTitle="personalTitle"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{photo="photo"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{physicalDeliveryOfficeName="physicalDeliveryOfficeName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{possibleInferiors="possibleInferiors"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{postalAddress="postalAddress"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{postalCode="postalCode"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{postOfficeBox="postOfficeBox"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{preferredDeliveryMethod="preferredDeliveryMethod"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{preferredLanguage="preferredLanguage"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{preferredOU="preferredOU"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{primaryGroupID="primaryGroupID"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{primaryInternationalISDNNumber="primaryInternationalISDNNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{primaryTelexNumber="primaryTelexNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{profilePath="profilePath"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{proxiedObjectName="proxiedObjectName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{proxyAddresses="proxyAddresses"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{pwdLastSet="pwdLastSet"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{queryPolicyBL="queryPolicyBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{registeredAddress="registeredAddress"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{replPropertyMetaData="replPropertyMetaData"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{replUpToDateVector="replUpToDateVector"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{repsFrom="repsFrom"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{repsTo="repsTo"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{revision="revision"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{rid="rid"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{roomNumber="roomNumber"}
#########################set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{sAMAccountName="sAMAccountName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{sAMAccountType="sAMAccountType"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{scriptPath="scriptPath"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{sDRightsEffective="sDRightsEffective"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{secretary="secretary"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{securityIdentifier="securityIdentifier"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{seeAlso="seeAlso"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{serialNumber="serialNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{serverReferenceBL="serverReferenceBL"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{servicePrincipalName="servicePrincipalName"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowExpire="shadowExpire"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowFlag="shadowFlag"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowInactive="shadowInactive"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowLastChange="shadowLastChange"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowMax="shadowMax"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowMin="shadowMin"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{shadowWarning="shadowWarning"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{showInAddressBook="showInAddressBook"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{showInAdvancedViewOnly="showInAdvancedViewOnly"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{sIDHistory="sIDHistory"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{siteObjectBL="siteObjectBL"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{sn="sn"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{st="st"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{street="street"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{streetAddress="streetAddress"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{structuralObjectClass="structuralObjectClass"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{subRefs="subRefs"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{subSchemaSubEntry="subSchemaSubEntry"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{supplementalCredentials="supplementalCredentials"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{systemFlags="systemFlags"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{telephoneNumber="telephoneNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{teletexTerminalIdentifier="teletexTerminalIdentifier"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{telexNumber="telexNumber"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{terminalServer="terminalServer"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{textEncodedORAddress="textEncodedORAddress"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{thumbnailLogo="thumbnailLogo"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{thumbnailPhoto="thumbnailPhoto"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{title="title"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{tokenGroups="tokenGroups"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{tokenGroupsGlobalAndUniversal="tokenGroupsGlobalAndUniversal"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{tokenGroupsNoGCAcceptable="tokenGroupsNoGCAcceptable"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uid="uid"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uidNumber="uidNumber"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{unicodePwd="unicodePwd"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{unixHomeDirectory="unixHomeDirectory"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{unixUserPassword="unixUserPassword"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{url="url"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userAccountControl="userAccountControl"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userCert="userCert"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userCertificate="userCertificate"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userParameters="userParameters"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userPassword="userPassword"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userPKCS12="userPKCS12"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userPrincipalName="userPrincipalName"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userSharedFolder="userSharedFolder"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userSharedFolderOther="userSharedFolderOther"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userSMIMECertificate="userSMIMECertificate"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{userWorkstations="userWorkstations"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uSNChanged="uSNChanged"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uSNCreated="uSNCreated"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uSNDSALastObjRemoved="uSNDSALastObjRemoved"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{USNIntersite="USNIntersite"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uSNLastObjRem="uSNLastObjRem"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{uSNSource="uSNSource"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{wbemPath="wbemPath"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{wellKnownObjects="wellKnownObjects"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{whenChanged="whenChanged"}
#set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{whenCreated="whenCreated"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{wWWHomePage="wWWHomePage"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{x121Address="x121Address"}
set-adobject -Identity "CN=kkkk,OU=perf,DC=megacorp,DC=local" -replace @{x500uniqueIdentifier="x500uniqueIdentifier"}



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
#>