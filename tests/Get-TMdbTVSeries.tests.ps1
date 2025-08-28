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

    Get-TMdbTVSeries -i 615 -ccc -img -xid -isd -ccs -imgs -xids -cce -imge -xide

  # Execute a request using a valid TMDB TV Show ID. (Fargo = 60622, Futurama = 615, Gilligan = 1921)
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVShow :: Futurama (615) :: All Options' )
    $myShow = $(Get-TMdbTVShow -i 615 -ccc -img -xid -isd -ccs -imgs -xids -ccse).value # -imge -xide

    exit

  # Execute a request to get the basic Series data.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Basic Series Data Only' )
    Get-TMdbTVSeries -SeriesID 615

  # Execute a request to get the full Series data.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries :: Full Series Data, Limited Season Data, No Episode Data' )
    Get-TMdbTVSeries -SeriesID 615 -IncludeCastAndCrewCredits -IncludeImages -IncludeExternalIDs

  # USE THIS :: Execute a request to get the full Series and Season data (with Episodes).
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: Full Series and Season Data (Includes Episodes)' )
    Get-TMdbTVSeries -i 615 -ccc -img -xid -isd -ccs -imgs -xids -ccse

  # DO NOT USE THIS - IT'S ABUSIVE TO TMDB :: Full Series, Season and Episode-specific credits/external IDs.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeason :: Full Series, Season and all Episode-Specific Data' )
    Get-TMdbTVSeries -i 615 -ccc -img -xid -isd -ccs -imgs -xids -cce -imge -xide

  # Execute a search for a show that doesn't exist.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVSeries:: ** FAILURE EXPECTED ** ' )
    Get-TMdbTVSeries -i 19211921
