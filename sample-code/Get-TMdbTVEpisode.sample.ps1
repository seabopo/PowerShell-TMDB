#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVEpisode
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

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

  # Load the standard test initialization file.
  . $(Join-Path -Path $PSScriptRoot -ChildPath '_init-test-environment.ps1')

#==================================================================================================================
# Testing
#==================================================================================================================

  # Import the MediaClasses module to load the classes in the local user session. This MUST be done in the primary
  # script/session or the classes won't be seen by all sub-components. Also note that you CANNOT -Force reload 
  # this module. A fresh session must be started to reload classes and enums from a PowerShell module.
  # This module uses the "ScriptsToProcess" Work-Around rather than using the documented "using module" method
  # as "using module" seems to work poorly in VSCode's PowerShell debugger.
    Import-Module 'po.MediaClasses'

  # Initialize the API Key / Bearer Token. api-token.ps1 contains a single line: return '<my api token>'
    $env:TMDB_API_TOKEN = . '.\_api-token.ps1'

  # Execute a request for all available Episode options.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: ** WITH ** All Options' )
    Get-TMdbTVEpisode -i 615 -s 1 -e 1 -cce -xide -imge

    exit

  # Execute a request for only the basic Episode Details.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: Basic Details' )
    Get-TMdbTVEpisode -ShowID 615 -SeasonNumber 1 -EpisodeNumber 1

  # Execute a request for Cast Credits.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: ** WITH ** Cast Credits' )
    Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeCastCredits

  # Execute a request for External IDs.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: ** WITH ** External IDs' )
    Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeExternalIDs

  # Execute a request for Images.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: ** WITH ** Images' )
    Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeImages

  # Execute a request for all Episode details.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: ** WITH ** All Options' )
    Get-TMdbTVEpisode -i 615 -s 1 -e 1 -cce -xide -imge

  # Execute an INVALID request.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVEpisode :: ** FAILURE EXPECTED ** ' )
    Get-TMdbTVEpisode -i 615 -s 1 -e 9999
