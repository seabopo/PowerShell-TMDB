#==================================================================================================================
#==================================================================================================================
# Test: Find-TMdb
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
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: TV Show' )
    Find-TMdb -TV -Query 'BattleStar Galactica' #-Year '2004'

    exit

  # Find a Show based on a name.
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: Name Contains Star Trek' )
    Find-TMdb -TV -Query 'Star Trek'

  # Execute a search that will provide a multiple results.
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: Name Contains Gilligan' )
    Find-TMdb -TV -Query "Gilligan"

  # Execute a search that will provide multiple pages of results.
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: Name Contains Miami' )
    Find-TMdb -TV -Query 'Miami'

  # Find a Movie based on a name.
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: Movie Name Only' )
    Find-TMdb -Movie -Query 'The Fifth Element'

  # Find a Movie based on the Name and Year.
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: Movie Name and Year' )
    Find-TMdb -Movie -Query 'Aladdin' -Year '1992'

  # Execute a search that will exceed the maximum defined results (Default = 100).
    Write-Msg -h -ps -bb -m $( ' Find-TMdb :: ** FAILURE EXPECTED ** ' )
    Find-TMdb -TV -Query 'Miami' -MaxResults 20 | Out-Null
