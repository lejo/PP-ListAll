# Check PS version
$ps_version = (get-host).version.major
if ($ps_version -lt 7) {
  Write-Host -f Red "Powershell version 7 or greater is required. You are using version $($ps_version)"
  exit 1
}

# Check for m365 CLI
$m365_command =  Get-Command -ErrorAction SilentlyContinue -Type Application m365
if (!$m365_command) {
  Write-Host -f Red "The m365 CLI is required. Install from https://pnp.github.io/cli-microsoft365/"
  exit 1
}


$m365Status = m365 status

if ($m365Status -eq "Logged Out") {
    # Connection to Microsoft 365
    m365 login --authType password --userName [USERNAME] --password [PASSWORD]
}

$environments = m365 pp environment list --asAdmin | ConvertFrom-Json

Write-Host -f Green "Processing $($environments.Count) environments";

$results = @()

$environments | ForEach-Object {
  Write-Host -f Green "Processing environment: $($_.displayName)"
  $envId = $($_.name)

  $results += [pscustomobject]@{
    type        = "environment"
    location    = $_.location
    id          = $envId
    displayName = $_.displayName
    envId       = $envId
    lifeCycleId = $_.properties.environmentSku
    isDefault    = $_.isDefault
    databasetype = $_.databaseType
    createdByUpn = $_.properties.createdBy.userPrincipalName
  }

  $apps = m365 pa app list --environmentName $envId --asAdmin | ConvertFrom-Json -AsHashTable

  if ($apps -ne $null) {
      Write-Host -f Green "Processing: $($apps.Count) apps"

      $apps | ForEach-Object {

        $name = ""
        if ($_.name -eq $null) {
            $name = "<UNKNOWN ID>"
        } else {
            $name = $_.name
        }

        $results += [pscustomobject]@{
          type              = $_.appType
          id                = $name
          displayName       = $_.displayName.Replace(" ","").Replace("/","_").Replace(">","_").Replace("|","_")
          envId             = $envId
          lifeCycleId       = $_.properties.lifeCycleId
          status            = $_.properties.status
          createdByUpn      = $_.properties.createdBy.userPrincipalName
          lastDraftVersion  = $_.properties.lastDraftVersion
        }
      }
  } else {
    Write-Host "No apps found in $envId"
  }


#Read more: https://www.sharepointdiary.com/2021/12/check-null-not-null-empty-in-powershell.html#ixzz8TYHuPhpx

  $flows = m365 flow list --environmentName $envId --asAdmin --includeSolutions | ConvertFrom-Json -AsHashTable

  if ($flows -ne $null) {
      Write-Host -f Green "Processing: $($flows.Count) flows"

      $flows | ForEach-Object {
        $createUser = m365 aad user get --id $_.properties.creator.userId | ConvertFrom-Json 

        $name = ""
        if ($_.name -eq $null) {
            $name = "<UNKNOWN ID>"
        } else {
            $name = $_.name
        }

        $results += [pscustomobject]@{
          type          = "flow"
          id            = $name
          displayName   = $_.displayName.Replace(" ","").Replace("/","_").Replace(">","_").Replace("|","_")
          envId         = $envId
          lifeCycleId   = $_.properties.lifeCycleId
          status        = $_.properties.state
          createdByUpn  = $createUser.userPrincipalName
        }
      }
  } else {
    Write-Host "No flows found in $envId"
  }

}

$results | Export-Csv -Path .\PowerPlatform-Export-ALL.csv -NoTypeInformation

Write-Host -f Green "***** INVENTORY DISCOVERY COMPLETE *****"