Function Test-ApiTokenSet {
    <#
    .DESCRIPTION
        Test for the existence of the API token at $env:TMDB_API_TOKEN

    .OUTPUTS
        Boolean
   
    .EXAMPLE
        Test-ApiTokenSet

    #>
    [OutputType([void])]
    [CmdletBinding()]
    param ( )

    process {
        
        if ( $null -eq $env:TMDB_API_TOKEN ) { return $false } else { return $true }

    }
}
