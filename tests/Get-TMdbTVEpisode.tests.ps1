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

            $result = Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 `
                                         -IncludeEpisodeCastCredits -IncludeEpisodeExternalIDs -IncludeEpisodeImages
            $result.success | Should -BeTrue

            $episode = $result.value
            
            $episode.Source         | Should -Be 'TMDB'
            $episode.ID             | Should -Be '35006'
            $episode.ShowID         | Should -Be '615'
            $episode.Season         | Should -Be 1
            $episode.Number         | Should -Be 1
            $episode.Type           | Should -Be 'standard'
            $episode.Title          | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode | Should -Be '1ACV01'
            $episode.AirDate        | Should -Be '1999-03-28'
            $episode.Runtime        | Should -Be 22
            $episode.ExternalIDs    | Should -HaveCount 7
            $episode.Images         | Should -HaveCount 2
            $episode.cast           | Should -HaveCount 10
            $episode.crew           | Should -HaveCount 4
            $episode.guests         | Should -HaveCount 3
            $episode.cast           | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.crew           | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.guests         | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'
            
        }

        It 'Test all parameter aliases' {

            $result = Get-TMdbTVEpisode -t 615 -s 1 -e 1 -cce -xide -imge
            $result.success | Should -BeTrue

            $episode = $result.value

            $episode.Source         | Should -Be 'TMDB'
            $episode.ID             | Should -Be '35006'
            $episode.ShowID         | Should -Be '615'
            $episode.Season         | Should -Be 1
            $episode.Number         | Should -Be 1
            $episode.Type           | Should -Be 'standard'
            $episode.Title          | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode | Should -Be '1ACV01'
            $episode.AirDate        | Should -Be '1999-03-28'
            $episode.Runtime        | Should -Be 22
            $episode.ExternalIDs    | Should -HaveCount 7
            $episode.Images         | Should -HaveCount 2
            $episode.cast           | Should -HaveCount 10
            $episode.crew           | Should -HaveCount 4
            $episode.guests         | Should -HaveCount 3
            $episode.cast           | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.crew           | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.guests         | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'

        }

    }

}
