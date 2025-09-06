#==================================================================================================================
#==================================================================================================================
# Test: Find-TMdb
#==================================================================================================================
#==================================================================================================================
#
# Sample Data
# -----------------------------------------------------------------------------------------------------------------
# Series / Movie Name                                  ID    Seasons    Episodes
# -----------------------------------------------------------------------------------------------------------------
# Futurama                                            615      10        150+
# Luther                                             1426       5         20
# Gilligan's Island                                  1921       3         98
# Gilligan's Planet                                   631       1         13
# The New Adventures of Gilligan                     2982       2         24
# Battlestar Galactica (1978)                         501       1         21
# Battlestar Galactica (2004)                        1972       4         75
#
# Aladdin (1992)                                      812
# The Fifth Element (1997)                             18
# Harry Potter and the Philosopher's Stone (2001)     671
# Black Widow                                      497698
# John Wick                                        245891
#
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session.
  Import-Module 'po.MediaClasses'

# Override the Default Debug Logging Setting
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

Describe 'TMDB Search Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Find-TMdb - TV Series' {

        It 'Get the results of a TV Show Search for Star Trek' {
            $results = Find-TMdb -TV -Query 'Star Trek'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 27
            $results.value   | Where-Object { $_.Name -eq 'Star Trek: Deep Space Nine' } | Should -HaveCount 1
        }

        It 'Get the results of a TV Show Search with a Year for Gilligans Island' {
            $results = Find-TMdb -TV -Query  "Gilligan's Island" -Year '1964'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 1
        }

        It 'Get the results of a TV Show Search with all Years for Gilligans Island' {
            $results = Find-TMdb -TV -Query  "Gilligan's Island" -AllYears '1965'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 1
        }

        It 'Test all parameter aliases' {
            $ratings = Find-TMdb -t -q 'Futurama'
            $ratings.success | Should -BeTrue
            $ratings.value   | Should -HaveCount 1
        }

    }

    Describe 'Find-TMdb - Movie' {

        It 'Get the results of a Movie Search for Harry Potter' {
            $results = Find-TMdb -Movie -Query 'Harry Potter'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 24
            $results.value   | Where-Object { $_.Title -eq "Harry Potter and the Philosopher's Stone" } | 
                               Should -HaveCount 1
        }

        It 'Get the results of a Movie Search with a Year for Aladdin' {
            $results = Find-TMdb -Movie -Query "Aladdin" -Year '1992'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 4
        }

        It 'Test all parameter aliases' {
            $results = Find-TMdb -m -q 'The Fifth Element'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 2
        }

    }

}
