#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVGenres
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

Describe 'TMDB Genre Testing' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVGenres' {

        It 'Given no parameters, it lists all genres of the users local language' {
            $genres = Get-TMdbTVGenres
            $genres.success | Should -Be $true
            $genres.value.count | Should -Be 16
        }

        It 'Given the "en-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbTVGenres -Language 'en-US'
            $genres.success | Should -Be $true
            $genres.value.count | Should -Be 16
            $genreNames = $genres.value.values
            $genreNames -contains 'Action & Adventure' | Should -Be $true
            $genreNames -contains 'Comedy'             | Should -Be $true
            $genreNames -contains 'Drama'              | Should -Be $true
            $genreNames -contains 'Kids'               | Should -Be $true
            $genreNames -contains 'Sci-Fi & Fantasy'   | Should -Be $true
            $genreNames -contains 'Animation'          | Should -Be $true
        }

        It 'Given the "es-US" language, it lists all 19 genres of the english language' {
            $genres = Get-TMdbTVGenres -Language 'es-US'
            $genres.success | Should -Be $true
            $genres.value.count | Should -Be 16
            $genreNames = $genres.value.values
            $genreNames -contains 'Action & Adventure' | Should -Be $true
            $genreNames -contains 'Comedia'            | Should -Be $true
            $genreNames -contains 'Drama'              | Should -Be $true
            $genreNames -contains 'Kids'               | Should -Be $true
            $genreNames -contains 'Sci-Fi & Fantasy'   | Should -Be $true
            $genreNames -contains 'Animación'          | Should -Be $true
        }

    }

}