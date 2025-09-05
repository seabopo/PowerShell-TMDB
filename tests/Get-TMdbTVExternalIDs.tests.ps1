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

# Import the MediaClasses module to load the classes in the local user session.
  Import-Module 'po.MediaClasses'

# Override the Default Debug Logging Setting
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB External ID Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVExternalIDs' {

        It 'Get IDs for a TV Show Episode' {
            $xIDs = Get-TMdbTVExternalIDs -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 7
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -BeTrue
            $names -contains 'imdb'   | Should -BeTrue
            $names -contains 'tvdb'   | Should -BeTrue
            $names -contains 'tvrage' | Should -BeTrue
        }

        It 'Get IDs for a TV Show Season' {
            $xIDs = Get-TMdbTVExternalIDs -SeriesID 615 -SeasonNumber 1
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 4
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'         | Should -BeTrue
            $names -contains 'freebase_mid' | Should -BeTrue
            $names -contains 'tvdb'         | Should -BeTrue
            $names -contains 'wikidata'     | Should -BeTrue
        }

        It 'Get IDs for a TV Show' {
            $xIDs = Get-TMdbTVExternalIDs -SeriesID 615
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 7
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -BeTrue
            $names -contains 'imdb'   | Should -BeTrue
            $names -contains 'tvdb'   | Should -BeTrue
            $names -contains 'tvrage' | Should -BeTrue
        }

        It 'Test all parameter aliases' {
            $xIDs = Get-TMdbTVExternalIDs -t 615 -s 1 -e 1
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 7
        }

    }

}
