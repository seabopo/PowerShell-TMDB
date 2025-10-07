#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVSeries
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

Describe 'TMDB TV Series Tests' {

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVSeries' {

        It 'Get Details for a TV Series with only Series-Level Details' {
            
            $result = Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits -IncludeImages -IncludeExternalIDs `
                                       -Language 'en-US'
            $result.success | Should -BeTrue

            $series = $result.value
            
            $series.Source           | Should -Be 'TMDB'
            $series.ID               | Should -Be '615'
            $series.Rating           | Should -Be 'TV-14'
            $series.Ratings          | Should -HaveCount 1
            $series.Genres           | Should -HaveCount 3
            $series.FirstAirDate     | Should -Be '1999-03-28'
            $series.Year             | Should -Be '1999'
            $series.Creators         | Should -HaveCount 1
            $series.Creators[0].name | Should -Be 'Matt Groening'
            $series.Cast             | Should -HaveCount 8
            $series.Crew             | Should -HaveCount 4
            $series.Cast             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $series.Crew             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $series.Country          | Should -HaveCount 1
            $series.Country[0]       | Should -Be 'US'
            $series.Studios          | Should -HaveCount 3
            $series.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'The Curiosity Company'
            $series.Networks         | Should -HaveCount 3
            $series.Networks         | Select-Object -ExpandProperty 'name' | Should -Contain 'Hulu'
            $series.Seasons.count    | Should -BeGreaterOrEqual 11
            $series.ExternalIDs      | Should -HaveCount 7
            $series.Images.count     | Should -BeGreaterOrEqual 140

        }

        It 'Get Details for a TV Show with Season-Level Details' {
            
            $result = Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits -IncludeImages -IncludeExternalIDs `
                                       -IncludeSeasonDetails -IncludeSeasonCastCredits -IncludeSeasonImages `
                                       -IncludeSeasonExternalIDs -IncludeSeasonCastCreditsForEpisodes `
                                       -Language 'en-US'
            $result.success | Should -BeTrue
            
            $series  = $result.value
            $season  = $series.seasons  | Where-Object { $_.number -eq 1 }
            $episode = $season.episodes | Where-Object { $_.title -eq 'Space Pilot 3000' }
            
            $series.Source           | Should -Be 'TMDB'
            $series.ID               | Should -Be '615'
            $series.Rating           | Should -Be 'TV-14'
            $series.Ratings          | Should -HaveCount 1
            $series.Genres           | Should -HaveCount 3
            $series.FirstAirDate     | Should -Be '1999-03-28'
            $series.Year             | Should -Be '1999'
            $series.Creators         | Should -HaveCount 1
            $series.Creators[0].name | Should -Be 'Matt Groening'
            $series.Cast             | Should -HaveCount 8
            $series.Crew             | Should -HaveCount 4
            $series.Cast             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $series.Crew             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $series.Country          | Should -HaveCount 1
            $series.Country[0]       | Should -Be 'US'
            $series.Studios          | Should -HaveCount 3
            $series.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'The Curiosity Company'
            $series.Networks         | Should -HaveCount 3
            $series.Networks         | Select-Object -ExpandProperty 'name' | Should -Contain 'Hulu'
            $series.Seasons.count    | Should -BeGreaterOrEqual 11
            $series.ExternalIDs      | Should -HaveCount 7
            $series.Images.count     | Should -BeGreaterOrEqual 140
            
            $season.Source           | Should -Be 'TMDB'
            $season.ID               | Should -Be '1868'
            $season.ShowID           | Should -Be '615'
            $season.Name             | Should -Be 'Season 1'
            $season.Number           | Should -Be 1
            $season.FirstAirDate     | Should -Be '1999-03-28'
            $season.Year             | Should -Be '1999'
            $season.Episodes         | Should -HaveCount 9
            $season.ExternalIDs      | Should -HaveCount 4
            $season.Images           | Should -HaveCount 15
            $season.cast             | Should -HaveCount 9
            $season.crew             | Should -HaveCount 21
            $season.cast             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $season.crew             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $season.episodes         | Select-Object -ExpandProperty 'title' | Should -Contain 'I, Roommate'
            
            $episode.Title           | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode  | Should -Be '1ACV01'
            $episode.ExternalIDs     | Should -BeNullOrEmpty
            $episode.Images          | Should -BeNullOrEmpty
            $episode.cast            | Should -HaveCount 9
            $episode.crew            | Should -HaveCount 4
            $episode.guests          | Should -HaveCount 3
            $episode.cast            | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.crew            | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.guests          | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'

        }

        It 'Get Details for a TV Show Season with Episode-Level Details' {

            $result = Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits -IncludeImages -IncludeExternalIDs `
                                       -IncludeSeasonDetails -IncludeEpisodeCastCredits -IncludeEpisodeImages `
                                       -IncludeEpisodeExternalIDs -Language 'en-US'
            $result.success | Should -BeTrue
            
            $series  = $result.value
            $season  = $series.seasons  | Where-Object { $_.number -eq 1 }
            $episode = $season.episodes | Where-Object { $_.title -eq 'Space Pilot 3000' }
            
            $series.Source           | Should -Be 'TMDB'
            $series.ID               | Should -Be '615'
            $series.Rating           | Should -Be 'TV-14'
            $series.Ratings          | Should -HaveCount 1
            $series.Genres           | Should -HaveCount 3
            $series.FirstAirDate     | Should -Be '1999-03-28'
            $series.Year             | Should -Be '1999'
            $series.Creators         | Should -HaveCount 1
            $series.Creators[0].name | Should -Be 'Matt Groening'
            $series.Cast             | Should -HaveCount 8
            $series.Crew             | Should -HaveCount 4
            $series.Cast             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $series.Crew             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $series.Country          | Should -HaveCount 1
            $series.Country[0]       | Should -Be 'US'
            $series.Studios          | Should -HaveCount 3
            $series.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'The Curiosity Company'
            $series.Networks         | Should -HaveCount 3
            $series.Networks         | Select-Object -ExpandProperty 'name' | Should -Contain 'Hulu'
            $series.Seasons.count    | Should -BeGreaterOrEqual 11
            $series.ExternalIDs      | Should -HaveCount 7
            $series.Images.count     | Should -BeGreaterOrEqual 140
            
            $season.Source           | Should -Be 'TMDB'
            $season.ID               | Should -Be '1868'
            $season.ShowID           | Should -Be '615'
            $season.Name             | Should -Be 'Season 1'
            $season.Number           | Should -Be 1
            $season.FirstAirDate     | Should -Be '1999-03-28'
            $season.Year             | Should -Be '1999'
            $season.Episodes         | Should -HaveCount 9
            $season.episodes         | Select-Object -ExpandProperty 'title' | Should -Contain 'I, Roommate'
             
            $episode.Title           | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode  | Should -Be '1ACV01'
            $episode.ExternalIDs     | Should -HaveCount 7
            $episode.Images          | Should -HaveCount 2
            $episode.cast            | Should -HaveCount 9
            $episode.crew            | Should -HaveCount 4
            $episode.guests          | Should -HaveCount 3
            $episode.cast            | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.crew            | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.guests          | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'

        }

        It 'Test all parameter aliases' {
            $result = Get-TMdbTVShow -t 615 -ccc -img -xid -isd -ccs -imgs -xids -ccse
            $result.success | Should -BeTrue
            
            $series  = $result.value
            $season  = $series.seasons  | Where-Object { $_.number -eq 1 }
            $episode = $season.episodes | Where-Object { $_.title -eq 'Space Pilot 3000' }

            $series.Source           | Should -Be 'TMDB'
            $series.ID               | Should -Be '615'
            $series.Rating           | Should -Be 'TV-14'
            $series.Ratings          | Should -HaveCount 1
            $series.Genres           | Should -HaveCount 3
            $series.FirstAirDate     | Should -Be '1999-03-28'
            $series.Year             | Should -Be '1999'
            $series.Creators         | Should -HaveCount 1
            $series.Creators[0].name | Should -Be 'Matt Groening'
            $series.Cast             | Should -HaveCount 8
            $series.Crew             | Should -HaveCount 4
            $series.Cast             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $series.Crew             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $series.Country          | Should -HaveCount 1
            $series.Country[0]       | Should -Be 'US'
            $series.Studios          | Should -HaveCount 3
            $series.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'The Curiosity Company'
            $series.Networks         | Should -HaveCount 3
            $series.Networks         | Select-Object -ExpandProperty 'name' | Should -Contain 'Hulu'
            $series.Seasons.count    | Should -BeGreaterOrEqual 11
            $series.ExternalIDs      | Should -HaveCount 7
            $series.Images.count     | Should -BeGreaterOrEqual 140

            $season.Source           | Should -Be 'TMDB'
            $season.ID               | Should -Be '1868'
            $season.ShowID           | Should -Be '615'
            $season.Name             | Should -Be 'Season 1'
            $season.Number           | Should -Be 1
            $season.FirstAirDate     | Should -Be '1999-03-28'
            $season.Year             | Should -Be '1999'
            $season.Episodes         | Should -HaveCount 9
            $season.ExternalIDs      | Should -HaveCount 4
            $season.Images           | Should -HaveCount 15
            $season.cast             | Should -HaveCount 9
            $season.crew             | Should -HaveCount 21
            $season.cast             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Billy West'
            $season.crew             | Select-Object -ExpandProperty 'name'  | Should -Contain 'Matt Groening'
            $season.episodes         | Select-Object -ExpandProperty 'title' | Should -Contain 'I, Roommate'
 
            $episode.Title           | Should -Be 'Space Pilot 3000'
            $episode.ProductionCode  | Should -Be '1ACV01'
            $episode.cast            | Should -HaveCount 9
            $episode.crew            | Should -HaveCount 4
            $episode.guests          | Should -HaveCount 3
            $episode.cast            | Select-Object -ExpandProperty 'name' | Should -Contain 'Billy West'
            $episode.crew            | Select-Object -ExpandProperty 'name' | Should -Contain 'Matt Groening'
            $episode.guests          | Select-Object -ExpandProperty 'name' | Should -Contain 'Leonard Nimoy'

        }

    }

}
