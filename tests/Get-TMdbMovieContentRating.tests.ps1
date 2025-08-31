#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbMovieContentRatings
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

Describe 'TMDB Movie Content Ratings Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
        $defaultCountry = $((Get-Culture).Name.ToString().Split('-')[1])
    }

    Describe 'Get-TMdbMovieContentRatings' {

        It 'Get the default Content Rating for a Movie' {
            $ratings = Get-TMdbMovieContentRatings -MovieID 497698
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be $defaultCountry
        }

        It 'Get the US Content Rating for a Movie' {
            $ratings = Get-TMdbMovieContentRatings -MovieID 497698 -Country 'US'
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be 'US'
            $ratings.value.Rating  | Should -Be 'PG-13'
        }

        It 'Get the AU Content Rating for a Movie' {
            $ratings = Get-TMdbMovieContentRatings -MovieID 497698 -Country 'AU'
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 1
            $ratings.value.Country | Should -Be 'AU'
            $ratings.value.Rating  | Should -Be 'M'
        }

        It 'Get all available Content Ratings for a Movie' {
            $ratings = Get-TMdbMovieContentRatings -MovieID 497698 -AllRatings
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 39
        }

        It 'Test all parameter aliases' {
            $ratings = Get-TMdbMovieContentRatings -i 497698 -a
            $ratings.success       | Should -BeTrue
            $ratings.value         | Should -HaveCount 39
        }

    }

}