#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbContentRatings
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

  # Execute a request using a valid TMDB Movie ID.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings' )
    Get-TMdbContentRatings -m 497698

  # Execute a request using a valid TMDB TV Show ID.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Series' )
    Get-TMdbContentRatings -t 615

    exit

  # Execute a request using the default language value.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Series with Default Country' )
    Get-TMdbContentRatings -ShowID 615

  # Execute a request using a defined value.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Series with Specific Country' )
    Get-TMdbContentRatings -SeriesID 615 -Country "GB"

  # Execute a request using all values.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Series with All Countries' )
    Get-TMdbContentRatings -SeriesID 615 -AllRatings

  # Execute a request using the default language value.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Movie with Default Country' )
    Get-TMdbContentRatings -MovieID 497698

  # Execute a request using a defined value.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Movie with Specific Country' )
    Get-TMdbContentRatings -MovieID 497698 -Country "GB"

  # Execute a request using all values.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: Movie with All Countries' )
    Get-TMdbContentRatings -MovieID 497698 -AllRatings

  # Execute a request using an invalid TMDB TV Show ID.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbContentRatings :: ** FAILURE EXPECTED ** ' )
    Get-TMdbContentRatings -m 615615615
