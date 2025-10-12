#==================================================================================================================
#==================================================================================================================
# po.TMDB
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Module Initializations
#==================================================================================================================

    using namespace System.Collections.Generic
    using namespace System.Collections.Specialized
    using namespace System.Web.HttpUtility

    $ErrorActionPreference = "Stop"

    Set-Variable -Scope 'Script' -Name "PS_MODULE_ROOT"  -Value $PSScriptRoot
    Set-Variable -Scope 'Script' -Name "PS_MODULE_NAME"  -Value $($PSScriptRoot | Split-Path -Leaf)

    Set-Variable -Scope 'Script' -Name "API_BASE_URI"  -Value 'https://api.themoviedb.org/3'
    Set-Variable -Scope 'Script' -Name "IMG_BASE_URI"  -Value 'https://media.themoviedb.org/t/p/original'

    Set-Variable -Scope 'Script' -Name "TMDB_GENRE_LANGUAGE"
    Set-Variable -Scope 'Script' -Name "TMDB_TV_GENRES"
    Set-Variable -Scope 'Script' -Name "TMDB_MOVIE_GENRES"

    Set-Variable -Scope 'Script' -Name "TOKEN_NOT_SET" -Value 'The TMBD API token ($env:TMDB_API_TOKEN) is not set.'

    $defaultVerboseTypes = '["Header","Process","Information","Debug","FunctionCall","FunctionResult"]'

    if ( $null -eq $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES ) {
        $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES = $defaultVerboseTypes
    }

    if ( $null -eq $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES ) {
        $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false
    }

#==================================================================================================================
# Load Functions and Export Public Functions and Aliases
#==================================================================================================================

  # Define the root folder source lists for public and private functions
    $publicFunctionsRootFolders  = @('Public')
    $privateFunctionsRootFolders = @('Private')

  # Load all public functions
    $publicFunctionsRootFolders | ForEach-Object {
        Get-ChildItem -Path "$PS_MODULE_ROOT/$_/*.ps1" -Recurse | ForEach-Object { . $($_.FullName) }
    }

  # Export all the public functions and aliases (enable for testing only - it affects automatic function discovery)
    # Export-ModuleMember -Function * -Alias *

  # Load all private functions
    $privateFunctionsRootFolders | ForEach-Object {
        Get-ChildItem -Path "$PS_MODULE_ROOT/$_/*.ps1" -Recurse | ForEach-Object { . $($_.FullName) }
    }
