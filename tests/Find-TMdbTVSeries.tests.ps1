#==================================================================================================================
#==================================================================================================================
# Test: Find-TMdbTVSeries
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
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

Describe 'TMDB TV Series Search Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Find-TMdbTVSeries' {

        It 'Get the results of a TV Show Search for Star Trek' {
            $results = Find-TMdbTVShows -Name 'Star Trek'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 27
            $results.value   | Where-Object { $_.Name -eq 'Star Trek: Deep Space Nine' } | Should -HaveCount 1
        }

        It 'Get the results of a TV Show Search with a Year for Gilligans Island' {
            $results = Find-TMdbTVShows -Name "Gilligan's Island" -Year '1964'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 1
        }

        It 'Test all parameter aliases' {
            $ratings = Find-TMdbTVShows -n 'Futurama'
            $ratings.success | Should -BeTrue
            $ratings.value   | Should -HaveCount 1
        }

    }

}
