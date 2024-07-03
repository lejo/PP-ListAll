
# Requirements

## Ensure you have the propper permissions

- A [Power BI Administrator](https://docs.microsoft.com/en-us/power-bi/admin/service-admin-role) account to change the [Tenant Settings](https://docs.microsoft.com/en-us/power-bi/guidance/admin-tenant-settings)
- Permissions to create an [Azure Active Directory Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal) 
- Permissions to create/use an [Azure Active Directory Security Group](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal)

## Create a Service Principal & Security Group

> [!NOTE]  
> Azure Active Directory is now call Entra ID.

On Azure Active Directory:

1. Go to "App Registrations" select "New App" and leave the default options
2. Generate a new "Client Secret" on "Certificates & secrets" and save the Secret text
3. Save the App Id & Tenant Id on the overview page of the service principal
4. Create a new Security Group on Azure Active Directory and add the Service Principal above as member
5. Optionally add the following API Application level permissions on "Microsoft Graph" API with Administrator grant to get the license & user info data:
    - User.Read.All
    - Directory.Read.All

        ![image](https://user-images.githubusercontent.com/10808715/142396742-2d0b6de9-95ef-4b2a-8ca9-23c9f1527fa9.png)
        ![image](./Images/SP_APIPermission_Directory.png)
        <img width="762" alt="image" src="https://user-images.githubusercontent.com/10808715/169350157-a9ccb47d-2c65-4b1a-80a1-757b9b02536d.png">


## Authorize the Service Principal on PowerBI Tenant

As a Power BI Administrator go to the Power BI Tenant Settings and authorize the Security Group on the following tenant settings:

- "Allow service principals to use read-only Power BI admin APIs"
- "Allow service principals to use Power BI APIs"
- "Enhance admin APIs responses with detailed metadata"
- "Enhance admin APIs responses with DAX and mashup expressions"

![image](https://user-images.githubusercontent.com/10808715/142396547-d7ca63e4-929c-4d8f-81c1-70c8bb6452af.png)

# API's Used

| Scope      | Resource | API
| ----------- | -------- |  ---------------- |
| Power BI Metadata  | Workspaces,DataSets,Reports,Dashboards,Permissions,Schema & Lineage | [Admin Scan API – GetModifiedWorkspaces](https://docs.microsoft.com/en-us/rest/api/power-bi/admin/workspace-info-get-modified-workspaces); [Admin Scan API – PostWorkspaceInfo](https://docs.microsoft.com/en-us/rest/api/power-bi/admin/workspace-info-post-workspace-info); [Admin Scan API – GetScanStatus (loop)](https://docs.microsoft.com/en-us/rest/api/power-bi/admin/workspace-info-get-scan-status); [Admin Scan API – GetScanResult](https://docs.microsoft.com/en-us/rest/api/power-bi/admin/workspace-info-get-scan-result)

<br>
<br>

Basics
- Runtime - "PowerShell Core"
- Version 7.0

![image](https://user-images.githubusercontent.com/10808715/138612825-d6a18c1f-f6fd-429d-b96f-a9d9b867a3ee.png)


# Setup - As a Local PowerShell

![image](https://user-images.githubusercontent.com/10808715/121097907-b0f53000-c7ec-11eb-806c-36a6b461a0d5.png)

## Install Required PowerShell Modules (as Administrator)
```
Install-Module -Name MicrosoftPowerBIMgmt -RequiredVersion 1.2.1026
```
