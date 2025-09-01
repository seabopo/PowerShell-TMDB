#==================================================================================================================
#==================================================================================================================
# Test: Find-TMdbTVSeries
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

  # Execute a request for all available Series options.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbTVShows :: ** WITH ** All Options' )
    Find-TMdbTVShows -Name 'BattleStar Galactica' #-Year '2004'

    exit

  # Find a Show based on a name.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbTVSeries :: Name Contains Star Trek' )
    Find-TMdbTVSeries -Name 'Star Trek'

  # Find a Show based on the function alias.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbTVShows :: Name Contains Futurama' )
    Find-TMdbTVShows -Name 'Futurama'

  # Execute a search that will provide a multiple results.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbTVSeries :: Name Contains Gilligan' )
    Find-TMdbTVSeries -Name "Gilligan"

  # Execute a search that will provide multiple pages of results.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbTVSeries :: Name Contains Miami' )
    Find-TMdbTVSeries -Name 'Miami'

  # Execute a search that will exceed the maximum defined results (Default = 100).
    Write-Msg -h -ps -bb -m $( ' Find-TMdbTVSeries :: ** FAILURE EXPECTED ** ' )
    Find-TMdbTVSeries -Name 'Miami' -MaxResults 20 | Out-Null
