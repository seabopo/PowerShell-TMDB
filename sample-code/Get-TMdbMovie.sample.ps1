#==================================================================================================================
#==================================================================================================================
# Test: Get-TMdbMovie
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
  # this module. A fresh session must be started to reload classes andC enums from a PowerShell module.
  # This module uses the "ScriptsToProcess" Work-Around rather than using the documented "using module" method
  # as "using module" seems to work poorly in VSCode's PowerShell debugger.
    Import-Module 'po.MediaClasses'

  # Initialize the API Key / Bearer Token. api-token.ps1 contains a single line: return '<my api token>'
    $env:TMDB_API_TOKEN = . '.\_api-token.ps1'

  # Execute a request for all available options.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbMovie' )
    Get-TMdbMovie -MovieID 18 -IncludeImages -IncludeExternalIDs

    exit

  # Execute a request with no additional options.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbMovie - No Options' )
    Get-TMdbMovie -MovieID 671

  # Execute a request for all available options.
    Write-Msg -h -ps -bb -m $( ' Get-TMdbMovie - All Options' )
    Get-TMdbMovie -MovieID 671 -IncludeImages -IncludeExternalIDs

  # Execute a search that will exceed the maximum defined results (Default = 100).
    Write-Msg -h -ps -bb -m $( ' Get-TMdbMovie :: ** FAILURE EXPECTED ** ' )
    Get-TMdbMovie -MovieID 01234567890
