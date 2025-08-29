Function Get-TMdbMovieGenres {
    <#
    .DESCRIPTION
        Gets the list of available Movie Genres.

    .OUTPUTS
        An [Hashtable] containing the ID and Name of each Movie Genre.
            {
                "80"   : "Crime",
                "878"  : "Science Fiction",
                "18"   : "Drama",
                "9648" : "Mystery",
                "10770": "TV Movie",
                "37"   : "Western",
                "16"   : "Animation",
                "10402": "Music",
                "14"   : "Fantasy",
                "53"   : "Thriller",
                "10751": "Family",
                "36"   : "History",
                "27"   : "Horror",
                "28"   : "Action",
                "35"   : "Comedy",
                "10749": "Romance",
                "12"   : "Adventure",
                "10752": "War",
                "99"   : "Documentary"
            }

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbMovieGenres

    .EXAMPLE
        Get-TMdbMovieGenres -Language 'en-US'

    .EXAMPLE
        Get-TMdbMovieGenres -l 'en-US'

    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [Parameter()] [Alias('l')] [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {
        
        [Hashtable] $genres = @{}
        
        Write-Msg -FunctionCall -IncludeParameters

        $SearchURL = @( $( $API_BASE_URI ), $( '/genre/movie/list' ), $( '?language={0}' -f $Language ) ) -Join ''
         
        Write-Msg -p -ps -m ( 'Querying TMDB for Movie Genres ...' )
        Write-Msg -d -il 1 -m ( 'Token: {0}...' -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'    -f $SearchURL )

        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            ($r.value | ConvertFrom-Json).genres | 
                ForEach-Object { 
                    $genres[($_.id.ToString())] = $_.name
                }
        }
        else {
            Write-Msg -e -ps -ds -m $($r.message)
            $r.success = $false
        }

        Write-Msg -FunctionResult -m $( 'Genres: ') -o $genres

        return @{ success = $r.success; value = $genres }
    }
}
