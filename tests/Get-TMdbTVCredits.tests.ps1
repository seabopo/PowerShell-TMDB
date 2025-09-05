#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVCredits
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

Describe 'TMDB Credits Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVCredits' {

        It 'Get Credits for a TV Show Episode' {
            $credits = Get-TMdbTVCredits -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 10
            $credits.value.crew   | Should -HaveCount 4
            $credits.value.guests | Should -HaveCount 3
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $credits.value.guests | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
        }

        It 'Get Credits for a TV Show Episode' {
            $credits = Get-TMdbTVCredits -SeriesID 615 -SeasonNumber 1
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 10
            $credits.value.crew   | Should -HaveCount 21
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Katey Sagal'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'David X. Cohen'
        }

        It 'Get Credits for a TV Show Episode' {
            $credits = Get-TMdbTVCredits -SeriesID 615
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 9
            $credits.value.crew   | Should -HaveCount 4
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'John DiMaggio'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Ken Keeler'
        }

        It 'Test all parameter aliases' {
            $credits = Get-TMdbTVCredits -t 615 -s 1 -e 1
            $credits.success | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 10
            $credits.value.crew   | Should -HaveCount 4
            $credits.value.guests | Should -HaveCount 3
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $credits.value.guests | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
        }

    }

}
