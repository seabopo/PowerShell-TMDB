#==================================================================================================================
#==================================================================================================================
# Test: Find-TMdbMovie
#==================================================================================================================
#==================================================================================================================
#
# Sample Data
# -----------------------------------------------------------------------------------------------------------------
# Movie Name                                           ID
# -----------------------------------------------------------------------------------------------------------------
# Aladdin (1992)                                      812
# The Fifth Element (1997)                             18
# Harry Potter and the Philosopher's Stone (2001)     671
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

  # Execute a request for all available options.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbMovie' )
    Find-TMdbMovie -Name 'harry potter' -Year '2001'

    #exit

  # Find a Show based on a name.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbMovie :: Movie Name Only' )
    Find-TMdbMovie -Name 'The Fifth Element'

  # Find a Show based on the function alias.
    Write-Msg -h -ps -bb -m $( ' Find-TMdbMovie :: Movie Name and Year' )
    Find-TMdbMovie -Name 'Aladdin' -Year '1992'

  # Execute a search that will exceed the maximum defined results (Default = 100).
    Write-Msg -h -ps -bb -m $( ' Find-TMdbMovie :: ** FAILURE EXPECTED ** ' )
    Find-TMdbTVSeries -Name 'Love' -MaxResults 20 | Out-Null
