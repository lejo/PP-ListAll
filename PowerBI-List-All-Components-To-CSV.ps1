# Save the script to a .ps1 file (e.g., PowerBI-List-All-Components-To-CSV.ps1).
# Run the script in PowerShell. Make sure to run PowerShell as an administrator if needed.
# After execution, the script will export detailed information about Power BI workspaces, reports, datasets, data sources, permissions, dashboards, and more into a CSV file specified by $outputFilePath.

# Check PS version
$ps_version = (get-host).version.major
if ($ps_version -lt 7) {
  Write-Host -f Red "Powershell version 7 or greater is required. You are using version $($ps_version)"
  exit 1
}

Install-Module -Name MicrosoftPowerBIMgmt

# Authenticate to Power BI Service
Connect-PowerBIServiceAccount

# Import the Power BI Management module
Import-Module MicrosoftPowerBIMgmt

# Function to get dataset information
function Get-DatasetInfo {
    param (
        [string]$WorkspaceId
    )

    $datasets = Get-PowerBIDataset -WorkspaceId $WorkspaceId

    $datasetInfo = @()

    foreach ($dataset in $datasets) {
        $dataSources = Get-PowerBIDataSource -WorkspaceId $WorkspaceId -DatasetId $dataset.Id

        $dataSourceInfo = @()
        foreach ($dataSource in $dataSources) {
            $dataSourceInfo += @{
                DataSourceId = $dataSource.DatasourceId
                DataSourceType = $dataSource.DatasourceType
                DataSourceConnectionDetails = $dataSource.ConnectionDetails
            }
        }

        $datasetInfo += @{
            DatasetId = $dataset.Id
            DatasetName = $dataset.Name
            DatasetWebUrl = $dataset.WebUrl
            DataSources = $dataSourceInfo
        }
    }

    return $datasetInfo
}

# Define output CSV file path
$outputFilePath = ".\PowerBI_Inventory.csv"

# Initialize an array to store all data
$allData = @()

# Get all workspaces
$workspaces = Get-PowerBIWorkspace

foreach ($workspace in $workspaces) {
    $workspaceId = $workspace.Id
    $workspaceName = $workspace.Name

    # Get reports in the workspace
    $reports = Get-PowerBIReport -WorkspaceId $workspaceId

    foreach ($report in $reports) {
        $reportId = $report.Id
        $reportName = $report.Name
        $reportWebUrl = $report.WebUrl

        # Get datasets used in the report
        $datasetsUsed = Get-DatasetInfo -WorkspaceId $workspaceId | Where-Object { $_.DatasetId -in $report.DatasetId }

        # Get dashboards in the workspace
        $dashboards = Get-PowerBIDashboard -WorkspaceId $workspaceId

        # Get permissions for the workspace
        $permissions = Get-PowerBIWorkspaceUser -WorkspaceId $workspaceId

        # Prepare data for export
        foreach ($dataset in $datasetsUsed) {
            foreach ($dataSource in $dataset.DataSources) {
                $data = [PSCustomObject]@{
                    WorkspaceId = $workspaceId
                    WorkspaceName = $workspaceName
                    ReportId = $reportId
                    ReportName = $reportName
                    ReportWebUrl = $reportWebUrl
                    DatasetId = $dataset.DatasetId
                    DatasetName = $dataset.DatasetName
                    DatasetWebUrl = $dataset.DatasetWebUrl
                    DataSourceId = $dataSource.DataSourceId
                    DataSourceType = $dataSource.DataSourceType
                    DataSourceConnectionDetails = $dataSource.DataSourceConnectionDetails
                    DashboardCount = $dashboards.Count
                    PermissionUserCount = $permissions.Count
                }

                # Add data to the array
                $allData += $data
            }
        }
    }
}

# Export data to CSV
$allData | Export-Csv -Path $outputFilePath -NoTypeInformation

Write-Host "Power BI inventory exported to: $outputFilePath"
