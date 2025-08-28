#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVSeason
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

  # Execute a request with all options.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: ** ALL ** Options' )
    Get-TMdbTVSeason -i 615 -s 1 -ccs -imgs -xids -ccse -imge -xide

    exit
  
  # Execute a request using a valid TMDB TV Show ID and Season Number.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: ** NO ** Cast Credits' )
    Get-TMdbTVSeason -ShowID 615 -SeasonNumber 1

  # Execute a request and get the season cast credits.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: ** WITH ** Season Cast Credits, Images and External IDs' )
    Get-TMdbTVSeason -SeriesID 615 -SeasonNumber 1 -IncludeSeasonCastCredits -IncludeSeasonImages -IncludeSeasonExternalIDs

  # Execute a request and get the season cast credits applied to episodes.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: ** WITH ** Episode Cast Credits, Images and External IDs' )
    Get-TMdbTVSeason -SeriesID 615 -SeasonNumber 1 -IncludeEpisodeCastCredits -IncludeEpisodeImages -IncludeEpisodeExternalIDs

  # Execute a request and get the episode cast credits applied to episodes.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: ** WITH ** All Options using Season Cast Credits for Episodes' )
    Get-TMdbTVSeason -i 615 -s 1 -ccs -imgs -xids -ccse -imge -xide

  # Execute a search for a season that doesn't exist.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: ** FAILURE EXPECTED ** ' )
    Get-TMdbTVSeason -SeriesID 615 -SeasonNumber 999
