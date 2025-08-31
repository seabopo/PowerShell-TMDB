#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbMovieGenres
#==================================================================================================================
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session.
  Import-Module 'po.MediaClasses'

# Override the Default Debug Logging Setting
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB Movie Genre Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbMovieGenres' {

        It 'Given no parameters, it lists all genres of the users local language' {
            $genres = Get-TMdbMovieGenres
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 19
        }

        It 'Given the "en-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbMovieGenres -Language 'en-US'
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 19
            $genreNames = $genres.value.values
            $genreNames -contains 'Action'          | Should -BeTrue
            $genreNames -contains 'Comedy'          | Should -BeTrue
            $genreNames -contains 'Drama'           | Should -BeTrue
            $genreNames -contains 'Fantasy'         | Should -BeTrue
            $genreNames -contains 'Science Fiction' | Should -BeTrue
            $genreNames -contains 'Thriller'        | Should -BeTrue
        }

        It 'Given the "es-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbMovieGenres -Language 'es-US'
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 19
            $genreNames = $genres.value.values
            $genreNames -contains 'Acción'          | Should -BeTrue
            $genreNames -contains 'Comedia'         | Should -BeTrue
            $genreNames -contains 'Drama'           | Should -BeTrue
            $genreNames -contains 'Fantasía'        | Should -BeTrue
            $genreNames -contains 'Ciencia ficción' | Should -BeTrue
            $genreNames -contains 'Suspense'        | Should -BeTrue
        }

        It 'Test all parameter aliases' {
            $genres = Get-TMdbMovieGenres -l'en-US'
            $genres.success     | Should -BeTrue
            $genres.value.count | Should -Be 19
        }

    }

}
