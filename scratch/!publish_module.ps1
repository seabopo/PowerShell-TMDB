#==================================================================================================================
#==================================================================================================================
# Publish the Module to the local PowerShell Repository
#==================================================================================================================
#==================================================================================================================

    Set-Location  -Path $PSScriptRoot
    Push-Location -Path $PSScriptRoot

    Write-Msg -h -ps -bb -m $( ' Running AtomicParsley Read/Write Tests' )

  # Install PSResourceGet, if required.
    # Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion 1.1.1

  # Set the Repository Properties.
    $PSRepoName = 'TPO-PSRepo'
    $PSRepoURI  = '/Volumes/PSRepo'

  # Register the Repository if required.
    $repository = @{
        Name                 = $PSRepoName
        SourceLocation       = $PSRepoURI
        ScriptSourceLocation = $PSRepoURI
        InstallationPolicy   = 'Trusted'
    }
    # Register-PSRepository @repository
    # Get-PSRepository

  # Check for the standard repo name for PowerShell modules.
    if (((Get-Location).Path) -match 'PowerShell-[^/\\]*') {

      # Get the Repo and Module properties
        $repoName   = $Matches[0]
        $repoPath   = ((Get-Location).Path -Replace $('{0}.*' -f $repoName),$repoName)
        $moduleName = $($repoName.Replace('PowerShell-','po.'))
        $modulePath = Join-Path -Path $repoPath -ChildPath $moduleName

      # Publish the PowerShell module to the PowerShell Module Repo.
        Publish-Module -Repository $PSRepoName -Path $modulePath -NuGetApiKey 'ThisIsRequiredButNotUsed'

      # Install/Update the newly published PowerShell module on the local computer.
        if ( Get-Module -ListAvailable -Name $moduleName ) {
            Update-Module -Name $moduleName
        }
        else {
            Install-Module -Repository $PSRepoName -Name $moduleName
        }

      # Show the installed versions.
        Get-Module -Name $moduleName

        Write-Host ''
        Write-Host 'The module has been published and updated on the local computer.' -ForegroundColor Green

    }
    else {
        Write-Host 'Unexpected repo path found. Script execution halted.' -ForegroundColor Red
    }
