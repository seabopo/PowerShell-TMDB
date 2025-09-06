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
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Movie' )
    Get-TMdbImages -m 671

  # Execute a request using a valid TMDB TV Show ID.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: TV Episode' )
    Get-TMdbImages -t 615
    
    exit

  # Execute a request using a valid TMDB Movie ID using the default language.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Movie with default language' )
    Get-TMdbImages -MovieID 18

  # Execute a request using a valid TMDB Movie ID using specific languages.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Movie with two specified languages' )
    Get-TMdbImages -MovieID 18 -Languages @('en','de')

  # Execute a request using a valid TMDB Movie ID using a specific language.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Movie with all languages' )
    Get-TMdbImages -MovieID 18 -AllLanguages

  # Execute a request using a valid TV Show ID and Season Number and Episode Number.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Episode' )
    Get-TMdbImages -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

  # Execute a request using a valid TV Show ID and Season Number.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Season' )
    Get-TMdbImages -SeriesID 615 -SeasonNumber 1

  # Execute a request using a valid TV Show ID.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: Series' )
    Get-TMdbImages -ShowID 615

  # Execute a request using a valid TV Show ID and Season Number and an INVALID Episode Number.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbImages :: ** FAILURE EXPECTED ** ' )
    Get-TMdbImages -t 615 -s 1 -e 1111
