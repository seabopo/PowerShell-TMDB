#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVSeries
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

  # Execute a request to get All Series and Season Information, including episodes.
  #     $request = Get-TMdbTVShow -i 615 -ccc -img -xid -isd -ccs -imgs -xids -ccse
  #     if ( $request.success ) {
  #         $myShow = $request.value
  #     }
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Full Series and Season Data (Includes Episodes)' )
    $myShow = $(Get-TMdbTVShow -t 501 -ccc -img -xid -isd -ccs -imgs -xids -ccse).value

    exit

  # Execute a request to get the basic Series data.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Basic Series Data Only' )
    Get-TMdbTVSeries -SeriesID 615

  # Execute a request to get the full Series data.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Full Series Data, Limited Season Data, No Episode Data' )
    Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits -IncludeImages -IncludeExternalIDs

  # USE THIS :: Execute a request to get the full Series and Season data (with Episodes).
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Full Series and Season Data (Includes Episodes)' )
    Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits `
                                   -IncludeImages `
                                   -IncludeExternalIDs `
                                   -IncludeSeasonDetails `
                                   -IncludeSeasonCastCredits `
                                   -IncludeSeasonImages `
                                   -IncludeSeasonExternalIDs `
                                   -IncludeSeasonCastCreditsForEpisodes `
                                   -IncludeEpisodeImages `
                                   -IncludeEpisodeExternalIDs

  # DO NOT USE THIS - IT COULD BE CONSIDERED ABUSIVE TO TMDB
  # Get Full Series, Season and Episode-specific credits, images and external IDs.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Full Series, Season and all Episode-Specific Data' )
    Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits `
                                   -IncludeImages `
                                   -IncludeExternalIDs `
                                   -IncludeSeasonDetails `
                                   -IncludeSeasonCastCredits `
                                   -IncludeSeasonImages `
                                   -IncludeSeasonExternalIDs `
                                   -IncludeEpisodeCastCredits `
                                   -IncludeEpisodeImages `
                                   -IncludeEpisodeExternalIDs

  # Attempt a request for a show that doesn't exist.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries:: ** FAILURE EXPECTED ** ' )
    Get-TMdbTVSeries -t 19211921
