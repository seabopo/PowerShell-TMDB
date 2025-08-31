#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVGenres
#==================================================================================================================
#==================================================================================================================

Describe 'Azure Infrastructure Testing' {

    BeforeDiscovery {
        . $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')
        Import-Module 'po.MediaClasses'
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