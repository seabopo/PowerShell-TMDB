#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbTVGenres
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

  # Execute a request using the default language.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVGenres :: Default Language' )
    Get-TMdbTVGenres | Out-Null

  # Execute a request using a custom language.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVGenres :: Custom Language' )
    Get-TMdbTVGenres -Language 'es-US'

  # Execute a request using a non-existent language.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbTVGenres :: ** NULL GENRE NAMES EXPECTED ** ' )
    Get-TMdbTVGenres -Language 'xx-XX'
