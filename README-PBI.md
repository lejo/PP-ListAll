
# Power BI Inventory Export Script

This script automates the discovery and export of Power BI workspace, report, dataset, dashboard, data source, and permission information into a CSV file.

## Prerequisites

1. **Power BI Account**: Ensure you have access to a Power BI account with sufficient permissions to read information from workspaces and reports.
   
2. **Power BI PowerShell Module**: Install the `MicrosoftPowerBIMgmt` module if not already installed. You can install it using the following PowerShell command:
   ```powershell
   Install-Module -Name MicrosoftPowerBIMgmt

3. **PowerShell Execution Policy**: Ensure that PowerShell execution policy allows running scripts. You can set it to RemoteSigned with the following command:
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser


## Running the Script

1. **Download the Script**: Download the `PowerBI-List-All-Components-To-CSV.ps1` script provided.

2. **Edit Script (Optional)**: Open `PowerBI-List-All-Components-To-CSV.ps1` in a text editor to review or modify any parameters or configurations such as the output file path (`$outputFilePath`).

3. **Run the Script**:
   - Open PowerShell as an administrator.
   - Navigate to the directory where `PowerBI-List-All-Components-To-CSV.ps1` is located.
   - Run the script using the following command:
     ```powershell
     .\PowerBI-List-All-Components-To-CSV.ps1
     ```

4. **Review Output**: After the script completes, it will generate a CSV file containing Power BI inventory data. The default output file path is `PowerBI_Inventory.csv`. You can modify this path in the script if needed.


## Output Format

The exported CSV file will contain the following columns:

- **WorkspaceId**: The unique identifier of the Power BI workspace.
- **WorkspaceName**: The name of the Power BI workspace.
- **ReportId**: The unique identifier of the Power BI report.
- **ReportName**: The name of the Power BI report.
- **ReportWebUrl**: The web URL of the Power BI report.
- **DatasetId**: The unique identifier of the Power BI dataset.
- **DatasetName**: The name of the Power BI dataset.
- **DatasetWebUrl**: The web URL of the Power BI dataset.
- **DataSourceId**: The unique identifier of the Power BI data source.
- **DataSourceType**: The type of the Power BI data source.
- **DataSourceConnectionDetails**: Details about the connection to the Power BI data source.
- **DashboardCount**: The number of dashboards associated with the workspace.
- **PermissionUserCount**: The number of users with permissions to access the workspace.



# Requirements

## Ensure you have the proper permissions

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

| Scope      | Resource |
| ----------- | -------- |
| Power BI Metadata  | Workspaces,DataSets,Reports,Dashboards,  Permissions,Schema & Lineage|

<br>
<br>

Basics
- Runtime - "PowerShell Core"
- Version 7.0

![image](https://user-images.githubusercontent.com/10808715/138612825-d6a18c1f-f6fd-429d-b96f-a9d9b867a3ee.png)

