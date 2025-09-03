#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVEpisode
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

Describe 'TMDB TV Episode Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVEpisode' {

        It 'Get Details for a TV Show Episode' {
            $episode = Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 `
                                         -IncludeEpisodeCastCredits -IncludeEpisodeExternalIDs -IncludeEpisodeImages
            $episode.success              | Should -BeTrue
            $episode.value.Source         | Should -Be 'TMDB'
            $episode.value.ID             | Should -Be '35006'
            $episode.value.ShowID         | Should -Be '615'
            $episode.value.Season         | Should -Be 1
            $episode.value.Number         | Should -Be 1
            $episode.value.Type           | Should -Be 'standard'
            $episode.value.Title          | Should -Be 'Space Pilot 3000'
            $episode.value.ProductionCode | Should -Be '1ACV01'
            $episode.value.AirDate        | Should -Be '1999-03-28'
            $episode.value.Runtime        | Should -Be 22
            $episode.value.ExternalIDs    | Should -HaveCount 7
            $episode.value.Images         | Should -HaveCount 2
            $episode.value.cast           | Should -HaveCount 10
            $episode.value.crew           | Should -HaveCount 4
            $episode.value.guests         | Should -HaveCount 3
            $episode.value.cast           | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.value.crew           | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.value.guests         | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
        }

        It 'Test all parameter aliases' {
            $episode = Get-TMdbTVEpisode -i 615 -s 1 -e 1 -cce -xide -imge
            $episode.success              | Should -BeTrue
            $episode.value.Source         | Should -Be 'TMDB'
            $episode.value.ID             | Should -Be '35006'
            $episode.value.ShowID         | Should -Be '615'
            $episode.value.Season         | Should -Be 1
            $episode.value.Number         | Should -Be 1
            $episode.value.Type           | Should -Be 'standard'
            $episode.value.Title          | Should -Be 'Space Pilot 3000'
            $episode.value.ProductionCode | Should -Be '1ACV01'
            $episode.value.AirDate        | Should -Be '1999-03-28'
            $episode.value.Runtime        | Should -Be 22
            $episode.value.ExternalIDs    | Should -HaveCount 7
            $episode.value.Images         | Should -HaveCount 2
            $episode.value.cast           | Should -HaveCount 10
            $episode.value.crew           | Should -HaveCount 4
            $episode.value.guests         | Should -HaveCount 3
            $episode.value.cast           | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.value.crew           | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.value.guests         | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
        }

    }

}
