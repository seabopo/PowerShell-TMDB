Function Get-GenreNameFromID {
    <#
    .DESCRIPTION
        Gets the friendly Genre name from the TMDB Genre ID code.

    .OUTPUTS
        A single [String] object.

    .PARAMETER ID
        REQUIRED. String. Alias: -i. Genre ID.

    .EXAMPLE
        Get-GenreNameFromID -i "10759"
    
    .EXAMPLE
        "10759" | Get-GenreNameFromID

    #>
    [OutputType([String])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('i')] [String] $ID
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        if ( [String]::IsNullOrEmpty($Script:TMDB_GENRES) ) {
            $r = Get-TMdbTVGenres
            if ( $r.success ) {
                $Script:TMDB_GENRES = $r.value
            }
        }
        
        $genre = $Script:TMDB_GENRES.ContainsKey($ID) ? $Script:TMDB_GENRES[$ID] : ''

        Write-Msg -FunctionResult -m $( 'Genre Name: {0}' -f $genre )

        return $genre
    }
}
