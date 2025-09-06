#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbCredits
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
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB Credits Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbCredits - TV Series' {

        It 'Get Credits for a TV Series/Show Episode' {
            $credits = Get-TMdbCredits -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 10
            $credits.value.crew   | Should -HaveCount 4
            $credits.value.guests | Should -HaveCount 3
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $credits.value.guests | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
        }

        It 'Get Credits for a TV Series/Show Season' {
            $credits = Get-TMdbCredits -SeriesID 615 -SeasonNumber 1
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 10
            $credits.value.crew   | Should -HaveCount 21
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Katey Sagal'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'David X. Cohen'
        }

        It 'Get Credits for a TV Series/Show' {
            $credits = Get-TMdbCredits -SeriesID 615
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 9
            $credits.value.crew   | Should -HaveCount 4
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'John DiMaggio'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Ken Keeler'
        }

        It 'Test all parameter aliases' {
            $credits = Get-TMdbCredits -t 615 -s 1 -e 1
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 10
            $credits.value.crew   | Should -HaveCount 4
            $credits.value.guests | Should -HaveCount 3
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $credits.value.guests | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
        }

    }

    Describe 'Get-TMdbCredits - Movies' {

        It 'Get Credits for a Movie' {
            $credits = Get-TMdbCredits -MovieID 18
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 120
            $credits.value.crew   | Should -HaveCount 349
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Bruce Willis'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Luc Besson'
        }

        It 'Test all parameter aliases' {
            $credits = Get-TMdbCredits -m 18
            $credits.success      | Should -BeTrue
            $credits.value        | Should -HaveCount 1
            $credits.value.cast   | Should -HaveCount 120
            $credits.value.crew   | Should -HaveCount 349
            $credits.value.cast   | Select-Object -ExpandProperty 'name' | Should -Contain 'Bruce Willis'
            $credits.value.crew   | Select-Object -ExpandProperty 'name' | Should -Contain 'Luc Besson'
        }

    }

}
