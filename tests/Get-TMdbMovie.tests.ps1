#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbMovie
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
#
#==================================================================================================================

# Load the standard test initialization file.
. $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

# Import the MediaClasses module to load the classes in the local user session.
  Import-Module 'po.MediaClasses'

# Override the Default Debug Logging Setting
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB Movie Tests' {

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbMovie' {

        It 'Get Basic Details for a Movie' {

            $result = Get-TMdbMovie -MovieID 18
            $result.success | Should -BeTrue

            $movie  = $result.value
            
            $movie.Source           | Should -Be 'TMDB'
            $movie.ID               | Should -Be '18'
            $movie.Adult            | Should -BeFalse
            $movie.Title            | Should -Be 'The Fifth Element'
            $movie.Tagline          | Should -Be 'There is no future without it.'
            $movie.OriginalTitle    | Should -Be 'Le Cinquième Élément'
            $movie.OriginalLanguage | Should -Be 'fr'
            $movie.Genres           | Should -HaveCount 3
            $movie.Genres           | Select-Object -ExpandProperty 'name' | Should -Contain 'Science Fiction'
            $movie.ReleaseDate      | Should -Be '1997-05-02'
            $movie.Year             | Should -Be '1997'
            $movie.Rating           | Should -Be 'PG-13'
            $movie.Ratings          | Should -HaveCount 1
            $movie.Status           | Should -Be 'Released'
            $movie.Studios          | Should -HaveCount 1
            $movie.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'Gaumont'
            $movie.Runtime          | Should -Be 126
            $movie.Budget           | Should -Be 90000000
            $movie.Revenue          | Should -Be 263920180
            $movie.HomePage         | Should -Be 'https://www.sonypictures.com/movies/thefifthelement'
            $movie.BackdropPath     | Should -Be '/dwN0kPGrLbFRxyL3F3J3t4ShQx.jpg'
            $movie.PosterPath       | Should -Be '/fPtlCO1yQtnoLHOwKtWz7db6RGU.jpg'
            $movie.BackdropURL      | Should -Be 'https://media.themoviedb.org/t/p/original/dwN0kPGrLbFRxyL3F3J3t4ShQx.jpg'
            $movie.PosterURL        | Should -Be 'https://media.themoviedb.org/t/p/original/fPtlCO1yQtnoLHOwKtWz7db6RGU.jpg'
            $movie.cast             | Should -HaveCount 120
            $movie.crew             | Should -HaveCount 349
            $movie.cast             | Select-Object -ExpandProperty 'name' | Should -Contain 'Bruce Willis'
            $movie.crew             | Select-Object -ExpandProperty 'name' | Should -Contain 'Luc Besson'
            $movie.Collections      | Should -Be $null
            $movie.Images           | Should -Be $null
            $movie.ExternalIDs      | Should -HaveCount 1
            $movie.ExternalIDs      | Select-Object -ExpandProperty 'name' | Should -Contain 'imdb'
        }

        It 'Get All Details for a Movie' {

            $result = Get-TMdbMovie -MovieID 18 -IncludeImages -IncludeExternalIDs -Language 'en-US'
            $result.success | Should -BeTrue

            $movie  = $result.value
            
            $movie.Source           | Should -Be 'TMDB'
            $movie.ID               | Should -Be '18'
            $movie.Adult            | Should -BeFalse
            $movie.Title            | Should -Be 'The Fifth Element'
            $movie.Tagline          | Should -Be 'There is no future without it.'
            $movie.OriginalTitle    | Should -Be 'Le Cinquième Élément'
            $movie.OriginalLanguage | Should -Be 'fr'
            $movie.Genres           | Should -HaveCount 3
            $movie.Genres           | Select-Object -ExpandProperty 'name' | Should -Contain 'Science Fiction'
            $movie.ReleaseDate      | Should -Be '1997-05-02'
            $movie.Year             | Should -Be '1997'
            $movie.Rating           | Should -Be 'PG-13'
            $movie.Ratings          | Should -HaveCount 1
            $movie.Status           | Should -Be 'Released'
            $movie.Studios          | Should -HaveCount 1
            $movie.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'Gaumont'
            $movie.Runtime          | Should -Be 126
            $movie.Budget           | Should -Be 90000000
            $movie.Revenue          | Should -Be 263920180
            $movie.HomePage         | Should -Be 'https://www.sonypictures.com/movies/thefifthelement'
            $movie.BackdropPath     | Should -Be '/dwN0kPGrLbFRxyL3F3J3t4ShQx.jpg'
            $movie.PosterPath       | Should -Be '/fPtlCO1yQtnoLHOwKtWz7db6RGU.jpg'
            $movie.BackdropURL      | Should -Be 'https://media.themoviedb.org/t/p/original/dwN0kPGrLbFRxyL3F3J3t4ShQx.jpg'
            $movie.PosterURL        | Should -Be 'https://media.themoviedb.org/t/p/original/fPtlCO1yQtnoLHOwKtWz7db6RGU.jpg'
            $movie.cast             | Should -HaveCount 120
            $movie.crew             | Should -HaveCount 349
            $movie.cast             | Select-Object -ExpandProperty 'name' | Should -Contain 'Bruce Willis'
            $movie.crew             | Select-Object -ExpandProperty 'name' | Should -Contain 'Luc Besson'
            $movie.Collections      | Should -Be $null
            $movie.Images.count     | Should -BeGreaterOrEqual 100
            $movie.ExternalIDs      | Should -HaveCount 3
            $movie.ExternalIDs      | Select-Object -ExpandProperty 'name' | Should -Contain 'imdb'
        }

        It 'Test all parameter aliases' {

            $result = Get-TMdbMovie -m 18 -img -xid -l 'en-US'
            $result.success | Should -BeTrue

            $movie  = $result.value
            
            $movie.Source           | Should -Be 'TMDB'
            $movie.ID               | Should -Be '18'
            $movie.Adult            | Should -BeFalse
            $movie.Title            | Should -Be 'The Fifth Element'
            $movie.Tagline          | Should -Be 'There is no future without it.'
            $movie.OriginalTitle    | Should -Be 'Le Cinquième Élément'
            $movie.OriginalLanguage | Should -Be 'fr'
            $movie.Genres           | Should -HaveCount 3
            $movie.Genres           | Select-Object -ExpandProperty 'name' | Should -Contain 'Science Fiction'
            $movie.ReleaseDate      | Should -Be '1997-05-02'
            $movie.Year             | Should -Be '1997'
            $movie.Rating           | Should -Be 'PG-13'
            $movie.Ratings          | Should -HaveCount 1
            $movie.Status           | Should -Be 'Released'
            $movie.Studios          | Should -HaveCount 1
            $movie.Studios          | Select-Object -ExpandProperty 'name' | Should -Contain 'Gaumont'
            $movie.Runtime          | Should -Be 126
            $movie.Budget           | Should -Be 90000000
            $movie.Revenue          | Should -Be 263920180
            $movie.HomePage         | Should -Be 'https://www.sonypictures.com/movies/thefifthelement'
            $movie.BackdropPath     | Should -Be '/dwN0kPGrLbFRxyL3F3J3t4ShQx.jpg'
            $movie.PosterPath       | Should -Be '/fPtlCO1yQtnoLHOwKtWz7db6RGU.jpg'
            $movie.BackdropURL      | Should -Be 'https://media.themoviedb.org/t/p/original/dwN0kPGrLbFRxyL3F3J3t4ShQx.jpg'
            $movie.PosterURL        | Should -Be 'https://media.themoviedb.org/t/p/original/fPtlCO1yQtnoLHOwKtWz7db6RGU.jpg'
            $movie.cast             | Should -HaveCount 120
            $movie.crew             | Should -HaveCount 349
            $movie.cast             | Select-Object -ExpandProperty 'name' | Should -Contain 'Bruce Willis'
            $movie.crew             | Select-Object -ExpandProperty 'name' | Should -Contain 'Luc Besson'
            $movie.Collections      | Should -Be $null
            $movie.Images.count     | Should -BeGreaterOrEqual 100
            $movie.ExternalIDs      | Should -HaveCount 3
            $movie.ExternalIDs      | Select-Object -ExpandProperty 'name' | Should -Contain 'imdb'
        }

    }

}
