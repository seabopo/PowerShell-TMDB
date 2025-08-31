#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVImages
#==================================================================================================================
#==================================================================================================================
#
# Sample Data
# -----------------------------------------------------------------------------------------------------------------
# Series / Show Name                       ID    Seasons    Episodes
# -----------------------------------------------------------------------------------------------------------------
# Futurama                                 615      10        150+
# Luther                                  1426       5         20
# Gilligan's Island                       1921       3         98
# Gilligan's Planet                        631       1         13
# The New Adventures of Gilligan          2982       2         24
# Battlestar Galactica (1978)              501       1         21
# Battlestar Galactica (2004)             1972       4         75
#
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session. This MUST be done in the primary
# script/session or the classes won't be seen by all sub-components. Also note that you CANNOT -Force reload 
# this module. A fresh session must be started to reload classes and enums from a PowerShell module.
# This module uses the "ScriptsToProcess" Work-Around rather than using the documented "using module" method
# as "using module" seems to work poorly in VSCode's PowerShell debugger.
  Import-Module 'po.MediaClasses'

Describe 'TMDB Image Testing' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVImages' {

        It 'Get images for a TV Show Episode' {
            $images = Get-TMdbTVImages -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $images.success     | Should -Be $true
            $images.value.count | Should -Be 2
            $($images.value | Where-Object { $_.type -eq 'still'    }).Count | Should -Be 2
            $($images.value | Where-Object { $_.type -eq 'poster'   }).Count | Should -Be 0
            $($images.value | Where-Object { $_.type -eq 'backdrop' }).Count | Should -Be 0
            $($images.value | Where-Object { $_.type -eq 'logo'     }).Count | Should -Be 0
        }

        It 'Get images for a TV Show Season' {
            $images = Get-TMdbTVImages -SeriesID 615 -SeasonNumber 1
            $images.success     | Should -Be $true
            $images.value.count | Should -Be 15
            $($images.value | Where-Object { $_.type -eq 'still'    }).Count | Should -Be 0
            $($images.value | Where-Object { $_.type -eq 'poster'   }).Count | Should -Be 15
            $($images.value | Where-Object { $_.type -eq 'backdrop' }).Count | Should -Be 0
            $($images.value | Where-Object { $_.type -eq 'logo'     }).Count | Should -Be 0
        }

        It 'Get images for a TV Show' {
            $images = Get-TMdbTVImages -SeriesID 615
            $images.success     | Should -Be $true
            $images.value.count | Should -Be 145
            $($images.value | Where-Object { $_.type -eq 'still'    }).Count | Should -Be 0
            $($images.value | Where-Object { $_.type -eq 'poster'   }).Count | Should -Be 53
            $($images.value | Where-Object { $_.type -eq 'backdrop' }).Count | Should -Be 81
            $($images.value | Where-Object { $_.type -eq 'logo'     }).Count | Should -Be 11
        }

    }

}
