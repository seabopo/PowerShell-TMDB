#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbContentRatings
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

Describe 'TMDB Content Ratings Tests' {

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
        $defaultCountry = $((Get-Culture).Name.ToString().Split('-')[1])
    }

    Describe 'Get-TMdbContentRatings TV Series Tests' {

        It 'Get the default Content Rating for a TV Show' {
            $rating = Get-TMdbContentRatings -SeriesID 615
            $rating.success       | Should -BeTrue
            $rating.value         | Should -HaveCount 1
            $rating.value.Country | Should -Be $defaultCountry
        }

        It 'Get the US Content Rating for a TV Show' {
            $ratings = Get-TMdbContentRatings -SeriesID 615 -Country 'US'
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be 'US'
            $ratings.value.Rating  | Should -Be 'TV-14'
        }

        It 'Get the AU Content Rating for a TV Show' {
            $ratings = Get-TMdbContentRatings -SeriesID 615 -Country 'AU'
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be 'AU'
            $ratings.value.Rating  | Should -Be 'M'
        }

        It 'Get all available Content Ratings for a TV Show' {
            $ratings = Get-TMdbContentRatings -SeriesID 615 -AllRatings
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 35
        }

        It 'Test all parameter aliases' {
            $ratings = Get-TMdbContentRatings -t 615 -a
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 35
        }

    }

    Describe 'Get-TMdbContentRatings Movie Tests' {

        It 'Get the default Content Rating for a Movie' {
            $ratings = Get-TMdbContentRatings -MovieID 497698
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be $defaultCountry
        }

        It 'Get the US Content Rating for a Movie' {
            $ratings = Get-TMdbContentRatings -MovieID 497698 -Country 'US'
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be 'US'
            $ratings.value.Rating  | Should -Be 'PG-13'
        }

        It 'Get the AU Content Rating for a Movie' {
            $ratings = Get-TMdbContentRatings -MovieID 497698 -Country 'AU'
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be 'AU'
            $ratings.value.Rating  | Should -Be 'M'
        }

        It 'Get all available Content Ratings for a Movie' {
            $ratings = Get-TMdbContentRatings -MovieID 497698 -AllRatings
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 39
        }

        It 'Test all parameter aliases' {
            $ratings = Get-TMdbContentRatings -m 497698 -a
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 39
        }

    }

}
