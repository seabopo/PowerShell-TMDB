#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVContentRatings
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
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

Describe 'TMDB TV Content Ratings Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
        $defaultCountry = $((Get-Culture).Name.ToString().Split('-')[1])
    }

    Describe 'Get-TMdbTVContentRatings' {

        It 'Get the default Content Rating for a TV Show' {
            $rating = Get-TMdbTVContentRatings -i 615
            $rating.success       | Should -BeTrue
            $rating.value         | Should -HaveCount 1
            $rating.value.Country | Should -Be $defaultCountry
        }

        It 'Get the US Content Rating for a TV Show' {
            $rating = Get-TMdbTVContentRatings -i 615 -c 'US'
            $rating.success       | Should -BeTrue
            $rating.value         | Should -HaveCount 1
            $rating.value.Country | Should -Be 'US'
            $rating.value.Rating  | Should -Be 'TV-14'
        }

        It 'Get the AU Content Rating for a TV Show' {
            $rating = Get-TMdbTVContentRatings -i 615 -c 'AU'
            $rating.success       | Should -BeTrue
            $rating.value         | Should -HaveCount 1
            $rating.value.Country | Should -Be 'AU'
            $rating.value.Rating  | Should -Be 'M'
        }

        It 'Get all available Content Ratings for a TV Show' {
            $xIDs = Get-TMdbTVContentRatings -SeriesID 615 
            $rating = Get-TMdbTVContentRatings -i 615 -AllRatings
            $rating.success       | Should -BeTrue
            $rating.value         | Should -HaveCount 35
        }

    }

}
