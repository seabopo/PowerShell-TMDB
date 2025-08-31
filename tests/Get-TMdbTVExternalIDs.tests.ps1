#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVExternalIDs
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

Describe 'TMDB External ID Testing' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVExternalIDs' {

        It 'Get IDs for a TV Show Episode' {
            $xIDs = Get-TMdbTVExternalIDs -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $xIDs.success     | Should -Be $true
            $xIDs.value.count | Should -Be 7
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -Be $true
            $names -contains 'imdb'   | Should -Be $true
            $names -contains 'tvdb'   | Should -Be $true
            $names -contains 'tvrage' | Should -Be $true
        }

        It 'Get IDs for a TV Show Season' {
            $xIDs = Get-TMdbTVExternalIDs -SeriesID 615 -SeasonNumber 1
            $xIDs.success     | Should -Be $true
            $xIDs.value.count | Should -Be 4
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'         | Should -Be $true
            $names -contains 'freebase_mid' | Should -Be $true
            $names -contains 'tvdb'         | Should -Be $true
            $names -contains 'wikidata'     | Should -Be $true
        }

        It 'Get IDs for a TV Show' {
            $xIDs = Get-TMdbTVExternalIDs -SeriesID 615
            $xIDs.success     | Should -Be $true
            $xIDs.value.count | Should -Be 7
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -Be $true
            $names -contains 'imdb'   | Should -Be $true
            $names -contains 'tvdb'   | Should -Be $true
            $names -contains 'tvrage' | Should -Be $true
        }

    }

}
