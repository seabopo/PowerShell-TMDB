#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbExternalIDs
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

Describe 'TMDB External ID Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbExternalIDs for Movies' {

        It 'Get IDs for a Movie' {
            $xIDs = Get-TMdbExternalIDs -MovieID 18
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 3
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -BeTrue
            $names -contains 'imdb'   | Should -BeTrue
        }

        It 'Test all parameter aliases' {
            $xIDs = Get-TMdbExternalIDs -m 18
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 3
        }

    }

    Describe 'Get-TMdbExternalIDs for TV Series/Shows' {

        It 'Get IDs for a TV Show Episode' {
            $xIDs = Get-TMdbExternalIDs -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 7
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -BeTrue
            $names -contains 'imdb'   | Should -BeTrue
            $names -contains 'tvdb'   | Should -BeTrue
            $names -contains 'tvrage' | Should -BeTrue
        }

        It 'Get IDs for a TV Show Season' {
            $xIDs = Get-TMdbExternalIDs -SeriesID 615 -SeasonNumber 1
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 4
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'         | Should -BeTrue
            $names -contains 'freebase_mid' | Should -BeTrue
            $names -contains 'tvdb'         | Should -BeTrue
            $names -contains 'wikidata'     | Should -BeTrue
        }

        It 'Get IDs for a TV Show' {
            $xIDs = Get-TMdbExternalIDs -SeriesID 615
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 7
            $names = $xIDs.value | Select-Object -ExpandProperty 'name'
            $names -contains 'tmdb'   | Should -BeTrue
            $names -contains 'imdb'   | Should -BeTrue
            $names -contains 'tvdb'   | Should -BeTrue
            $names -contains 'tvrage' | Should -BeTrue
        }

        It 'Test all parameter aliases' {
            $xIDs = Get-TMdbExternalIDs -t 615 -s 1 -e 1
            $xIDs.success | Should -BeTrue
            $xIDs.value   | Should -HaveCount 7
        }

    }

}
