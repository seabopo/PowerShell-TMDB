#==================================================================================================================
#==================================================================================================================
# Generates the files required for a PowerShell module.
#==================================================================================================================
#==================================================================================================================

Set-Location  -Path $PSScriptRoot
Push-Location -Path $PSScriptRoot

if (((Get-Location).Path) -match 'PowerShell-[^/\\]*') {
    
    $repoName       = $Matches[0]
    $repoPath       = ((Get-Location).Path -Replace $('{0}.*' -f $repoName),$repoName)
    $moduleName     = $($repoName.Replace('PowerShell-','po.'))
    $modulePath     = Join-Path -Path $repoPath   -ChildPath $moduleName
    $privatePath    = Join-Path -Path $modulePath -ChildPath 'private'
    $publicPath     = Join-Path -Path $modulePath -ChildPath 'public'
    $dataPath       = Join-Path -Path $modulePath -ChildPath 'data'
    $manifestPath   = Join-Path -Path $modulePath -ChildPath $('{0}.psd1' -f $moduleName)
    $rootModulePath = Join-Path -Path $modulePath -ChildPath $('{0}.psm1' -f $moduleName)
    $tempModulePath = Join-Path -Path $repoPath   -ChildPath 'po.TEMPLATE.psm1'

    @($modulePath, $privatePath, $publicPath, $dataPath) | ForEach-Object {
        if ( -not (Test-Path -LiteralPath $_ -PathType Container) ) {
            New-Item -Path $_ -ItemType Directory
        }
    }

    $ModuleProperties = @{

        Path                    = "$manifestPath"
        RootModule              = "$moduleName.psm1"
        ModuleVersion           = '0.0.1'

        Author                  = 'Sean Powell (seabopo)'
        CompanyName             = ''
        Copyright               = '(c) Sean Powell. MIT License.'
        ReleaseNotes            = 'Initial module release.'

        CompatiblePSEditions    = @('Core', 'Desktop')
        PowerShellVersion       = '7.4.0'
        RequiredModules         = @('po.Toolkit')

    }

    if ( -not ( Test-Path -LiteralPath $manifestPath ) ) { 
        New-ModuleManifest @ModuleProperties #-PassThru 
    }

    if ( -not ( Test-Path -LiteralPath $rootModulePath ) ) { 
        if ( ( Test-Path -LiteralPath $tempModulePath ) ) { 
            Move-Item -LiteralPath $tempModulePath -Destination $rootModulePath
        }
        else {
            New-Item -Path $rootModulePath
        }
    }

    Write-Host ''
    Write-Host 'All module files created.' -ForegroundColor Green

}
else {
    Write-Host 'Unexpected repo path found. Script execution halted.' -ForegroundColor Red
}
