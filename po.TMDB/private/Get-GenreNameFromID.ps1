Function Get-GenreNameFromID {
    <#
    .DESCRIPTION
        Gets the friendly Genre name from the TMDB Genre ID code.

    .OUTPUTS
        A single [String] object.

    .PARAMETER ID
        REQUIRED. String. Alias: -i. Genre ID.

    .PARAMETER TV
        REQUIRED. String. Alias: -t. Get TV Genres.

    .PARAMETER Movie
        REQUIRED. String. Alias: -m. Get Movie Genres.

    .EXAMPLE
        Get-GenreNameFromID -TV -i "10759"
    
    .EXAMPLE
        "10759" | Get-GenreNameFromID -m

    #>
    [OutputType([String])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]      [Alias('i')] [String] $ID,
        [Parameter(Mandatory,ParameterSetName = "T")] [Alias('t')] [Switch] $TV,
        [Parameter(Mandatory,ParameterSetName = "M")] [Alias('m')] [Switch] $Movie
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        if ( $TV ) {
            if ( Test-IsNothing($Script:TMDB_TV_GENRES) ) {
                $r = Get-TMdbTVGenres
                if ( $r.success ) {
                    $Script:TMDB_TV_GENRES = $r.value
                }
            }
            $genre = $Script:TMDB_TV_GENRES.ContainsKey($ID) ? $Script:TMDB_TV_GENRES[$ID] : ''
        }
        else {
            if ( Test-IsNothing($Script:TMDB_MOVIE_GENRES) ) {
                $r = Get-TMdbMovieGenres
                if ( $r.success ) {
                    $Script:TMDB_MOVIE_GENRES = $r.value
                }
            }
            $genre = $Script:TMDB_MOVIE_GENRES.ContainsKey($ID) ? $Script:TMDB_MOVIE_GENRES[$ID] : ''
        }
        
        Write-Msg -FunctionResult -m $( 'Genre Name: {0}' -f $genre )

        return $genre
    }
}
