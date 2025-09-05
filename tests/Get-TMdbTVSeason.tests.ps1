#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVSeason
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

Describe 'TMDB TV Season Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVSeason' {

        It 'Get Details for a TV Show Season with Season-Level Details' {

            $result = Get-TMdbTVSeason -SeriesID 615 -SeasonNumber 1 -IncludeSeasonCastCreditsForEpisodes `
                                       -IncludeSeasonCastCredits -IncludeSeasonImages -IncludeSeasonExternalIDs
            $result.success | Should -BeTrue

            $season  = $result.value
            $episode = $season.episodes | Where-Object { $_.title -eq 'Space Pilot 3000' }

            $season.Source          | Should -Be 'TMDB'
            $season.ID              | Should -Be '1868'
            $season.ShowID          | Should -Be '615'
            $season.Name            | Should -Be 'Season 1'
            $season.Number          | Should -Be 1
            $season.FirstAirDate    | Should -Be '1999-03-28'
            $season.Year            | Should -Be '1999'
            $season.Episodes        | Should -HaveCount 9
            $season.ExternalIDs     | Should -HaveCount 4
            $season.Images          | Should -HaveCount 15
            $season.cast            | Should -HaveCount 10
            $season.crew            | Should -HaveCount 21
            $season.cast            | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $season.crew            | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $season.episodes        | Select-Object -ExpandProperty 'title' | Should -Contain 'I, Roommate'
            
            $episode.Title          | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode | Should -Be '1ACV01'
            $episode.ExternalIDs    | Should -BeNullOrEmpty
            $episode.Images         | Should -BeNullOrEmpty
            $episode.cast           | Should -HaveCount 10
            $episode.crew           | Should -HaveCount 4
            $episode.guests         | Should -HaveCount 3
            $episode.cast           | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.crew           | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.guests         | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'

        }

        It 'Get Details for a TV Show Season with Episode-Level Details' {

            $result = Get-TMdbTVSeason -SeriesID 615 -SeasonNumber 1 `
                                       -IncludeSeasonCastCredits -IncludeSeasonImages -IncludeSeasonExternalIDs `
                                       -IncludeEpisodeCastCredits -IncludeEpisodeImages -IncludeEpisodeExternalIDs
            $result.success | Should -BeTrue

            $season  = $result.value
            $episode = $season.episodes | Where-Object { $_.title -eq 'Space Pilot 3000' }

            $season.Source          | Should -Be 'TMDB'
            $season.ID              | Should -Be '1868'
            $season.ShowID          | Should -Be '615'
            $season.Name            | Should -Be 'Season 1'
            $season.Number          | Should -Be 1
            $season.FirstAirDate    | Should -Be '1999-03-28'
            $season.Year            | Should -Be '1999'
            $season.Episodes        | Should -HaveCount 9
            $season.ExternalIDs     | Should -HaveCount 4
            $season.Images          | Should -HaveCount 15
            $season.cast            | Should -HaveCount 10
            $season.crew            | Should -HaveCount 21
            $season.cast            | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $season.crew            | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $season.episodes        | Select-Object -ExpandProperty 'title' | Should -Contain 'I, Roommate'

            $episode.Title          | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode | Should -Be '1ACV01'
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

            $result = Get-TMdbTVSeason -t 615 -s 1 -ccs -xids -imgs -cce -xide -imge
            $result.success | Should -BeTrue

            $season  = $result.value
            $episode = $season.episodes | Where-Object { $_.title -eq 'Space Pilot 3000' }

            $season.Source          | Should -Be 'TMDB'
            $season.ID              | Should -Be '1868'
            $season.ShowID          | Should -Be '615'
            $season.Name            | Should -Be 'Season 1'
            $season.Number          | Should -Be 1
            $season.FirstAirDate    | Should -Be '1999-03-28'
            $season.Year            | Should -Be '1999'
            $season.Episodes        | Should -HaveCount 9
            $season.ExternalIDs     | Should -HaveCount 4
            $season.Images          | Should -HaveCount 15
            $season.cast            | Should -HaveCount 10
            $season.crew            | Should -HaveCount 21
            $season.cast            | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $season.crew            | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $season.episodes        | Select-Object -ExpandProperty 'title' | Should -Contain 'I, Roommate'

            $episode.Title          | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode | Should -Be '1ACV01'
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
