#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbImages
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
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB Image Tests' {

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbImages - TV Shows' {

        It 'Get images for a TV Show Episode' {
            $images = Get-TMdbImages -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 2
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 2
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 0
        }

        It 'Get images for a TV Show Season' {
            $images = Get-TMdbImages -SeriesID 615 -SeasonNumber 1
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 15
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 15
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 0
        }

        It 'Get images for a TV Show' {
            $images = Get-TMdbImages -SeriesID 615
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 147
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 54
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 81
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 12
        }

        It 'Test all parameter aliases' {
            $images = Get-TMdbImages -t 615 -s 1 -e 1 -l 'en-US'
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 2
        }

    }

    Describe 'Get-TMdbImages - Movies' {

        It 'Get images for a Movie with the default language' {
            $images = Get-TMdbImages -MovieID 615
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 65
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 34
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 26
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 5
            $images.value   | Where-Object { $_.language -eq 'en'   } | Should -HaveCount 42
            $images.value   | Where-Object { $_.language -eq 'xx'   } | Should -HaveCount 23
        }

        It 'Get images for a Movie with two specified languages' {
            $images = Get-TMdbImages -MovieID 615 -Languages @('en','de')
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 69
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 37
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 26
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 6
            $images.value   | Where-Object { $_.language -eq 'en'   } | Should -HaveCount 42
            $images.value   | Where-Object { $_.language -eq 'de'   } | Should -HaveCount 4
            $images.value   | Where-Object { $_.language -eq 'xx'   } | Should -HaveCount 23
        }

        It 'Get images for a Movie with all languages' {
            $images = Get-TMdbImages -MovieID 615 -AllLanguages
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 132
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 81
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 34
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 17
            $images.value   | Where-Object { $_.language -eq 'en'   } | Should -HaveCount 42
            $images.value   | Where-Object { $_.language -eq 'de'   } | Should -HaveCount 4
            $images.value   | Where-Object { $_.language -eq 'zh'   } | Should -HaveCount 5
            $images.value   | Where-Object { $_.language -eq 'xx'   } | Should -HaveCount 23
        }

        It 'Test all parameter aliases' {
            $images = Get-TMdbImages -m 615 -l 'en'
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 65
        }

    }

}
