#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVGenres
#==================================================================================================================
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session.
  Import-Module 'po.MediaClasses'

# Override the Default Debug Logging Setting
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB TV Genre Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVGenres' {

        It 'Given no parameters, it lists all genres of the users local language' {
            $genres = Get-TMdbTVGenres
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 16
        }

        It 'Given the "en-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbTVGenres -Language 'en-US'
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 16
            $genreNames = $genres.value.values
            $genreNames -contains 'Action & Adventure' | Should -BeTrue
            $genreNames -contains 'Comedy'             | Should -BeTrue
            $genreNames -contains 'Drama'              | Should -BeTrue
            $genreNames -contains 'Kids'               | Should -BeTrue
            $genreNames -contains 'Sci-Fi & Fantasy'   | Should -BeTrue
            $genreNames -contains 'Animation'          | Should -BeTrue
        }

        It 'Given the "es-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbTVGenres -Language 'es-US'
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 16
            $genreNames = $genres.value.values
            $genreNames -contains 'Action & Adventure' | Should -BeTrue
            $genreNames -contains 'Comedia'            | Should -BeTrue
            $genreNames -contains 'Drama'              | Should -BeTrue
            $genreNames -contains 'Kids'               | Should -BeTrue
            $genreNames -contains 'Sci-Fi & Fantasy'   | Should -BeTrue
            $genreNames -contains 'Animación'          | Should -BeTrue
        }

    }

}