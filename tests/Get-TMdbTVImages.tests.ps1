#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVImages
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
  # $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false

Describe 'TMDB Image Tests' {

    BeforeDiscovery {
        
    }

    BeforeAll {
        $env:TMDB_API_TOKEN = . '.\_api-token.ps1'
    }

    Describe 'Get-TMdbTVImages' {

        It 'Get images for a TV Show Episode' {
            $images = Get-TMdbTVImages -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 2
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 2
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 0
        }

        It 'Get images for a TV Show Season' {
            $images = Get-TMdbTVImages -SeriesID 615 -SeasonNumber 1
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 15
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 15
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 0
        }

        It 'Get images for a TV Show' {
            $images = Get-TMdbTVImages -SeriesID 615
            $images.success | Should -BeTrue
            $images.value   | Should -HaveCount 145
            $images.value   | Where-Object { $_.type -eq 'still'    } | Should -HaveCount 0
            $images.value   | Where-Object { $_.type -eq 'poster'   } | Should -HaveCount 53
            $images.value   | Where-Object { $_.type -eq 'backdrop' } | Should -HaveCount 81
            $images.value   | Where-Object { $_.type -eq 'logo'     } | Should -HaveCount 11
        }

    }

}
