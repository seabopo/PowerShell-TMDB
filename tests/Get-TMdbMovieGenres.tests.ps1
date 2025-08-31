#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbMovieGenres
#==================================================================================================================
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session. This MUST be done in the primary
# script/session or the classes won't be seen by all sub-components. Also note that you CANNOT -Force reload 
# this module. A fresh session must be started to reload classes and enums from a PowerShell module.
# This module uses the "ScriptsToProcess" Work-Around rather than using the documented "using module" method
# as "using module" seems to work poorly in VSCode's PowerShell debugger.
  Import-Module 'po.MediaClasses'

Describe 'Azure Infrastructure Testing' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbMovieGenres' {

        It 'Given no parameters, it lists all genres of the users local language' {
            $genres = Get-TMdbMovieGenres
            $genres.success | Should -Be $true
            $genres.value.count | Should -Be 19
        }

        It 'Given the "en-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbMovieGenres -Language 'en-US'
            $genres.success | Should -Be $true
            $genres.value.count | Should -Be 19
            $genreNames = $genres.value.values
            $genreNames -contains 'Action'          | Should -Be $true
            $genreNames -contains 'Comedy'          | Should -Be $true
            $genreNames -contains 'Drama'           | Should -Be $true
            $genreNames -contains 'Fantasy'         | Should -Be $true
            $genreNames -contains 'Science Fiction' | Should -Be $true
            $genreNames -contains 'Thriller'        | Should -Be $true
        }

        It 'Given the "es-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbMovieGenres -Language 'es-US'
            $genres.success | Should -Be $true
            $genres.value.count | Should -Be 19
            $genreNames = $genres.value.values
            $genreNames -contains 'Acción'          | Should -Be $true
            $genreNames -contains 'Comedia'         | Should -Be $true
            $genreNames -contains 'Drama'           | Should -Be $true
            $genreNames -contains 'Fantasía'        | Should -Be $true
            $genreNames -contains 'Ciencia ficción' | Should -Be $true
            $genreNames -contains 'Suspense'        | Should -Be $true
        }

    }

}
