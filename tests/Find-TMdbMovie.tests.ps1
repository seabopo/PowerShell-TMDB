#==================================================================================================================
#==================================================================================================================
# Test: Find-TMdbMovie
#==================================================================================================================
#==================================================================================================================
#
# Sample Data
# -----------------------------------------------------------------------------------------------------------------
# Movie Name                                           ID
# -----------------------------------------------------------------------------------------------------------------
# Aladdin (1992)                                      812
# The Fifth Element (1997)                             18
# Harry Potter and the Philosopher's Stone (2001)     671
#
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session.
  Import-Module 'po.MediaClasses'

# Override the Default Debug Logging Setting
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

Describe 'TMDB Movie Series Search Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Find-TMdbMovie' {

        It 'Get the results of a TV Show Search for Harry Potter' {
            $results = Find-TMdbMovie -Name 'Harry Potter'
            $results.success | Should -BeTrue
            $results.value   | Should -HaveCount 24
            $results.value   | Where-Object { $_.Title -eq "Harry Potter and the Philosopher's Stone" } | Should -HaveCount 1
        }

        It 'Get the results of a TV Show Search with a Year for Aladdin' {
            $results = Find-TMdbMovie -Name "Aladdin" -Year '1992'
            $results.success       | Should -BeTrue
            $results.value         | Should -HaveCount 4
        }

        It 'Test all parameter aliases' {
            $results = Find-TMdbMovie -n 'The Fifth Element'
            $results.success       | Should -BeTrue
            $results.value         | Should -HaveCount 2
        }

    }

}
