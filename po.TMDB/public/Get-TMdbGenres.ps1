Function Get-TMdbGenres {
    <#
    .DESCRIPTION
        Gets the list of available TV or Movie Genres.

    .OUTPUTS
        A [Hashtable] containing the ID and Name of each TV Series/Show Genre.
            @{
                "16"   : "Animation",
                "80"   : "Crime",
                "35"   : "Comedy",
                "10751": "Family",
                "10759": "Action & Adventure",
                "10763": "News",
                "99"   : "Documentary",
                "18"   : "Drama",
                "10767": "Talk",
                "37"   : "Western",
                "10762": "Kids",
                "9648" : "Mystery",
                "10764": "Reality",
                "10768": "War & Politics",
                "10766": "Soap",
                "10765": "Sci-Fi & Fantasy"
            }
        or a [Hashtable] containing the ID and Name of each Movie Genre.
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
    
    .PARAMETER Movie
        REQUIRED. Switch. Alias: -m. Get Movie genres.
    
    .PARAMETER TV
        REQUIRED. Switch. Alias: -t. Get TV Genres.

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbGenres -TV -Language 'en-US'
        
    .EXAMPLE
        Get-TMdbGenres -Movie

    .EXAMPLE
        Get-TMdbGenres -t -l 'en-US'
        
    .EXAMPLE
        Get-TMdbGenres -m

    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = "M", Mandatory)]
        [Alias('m')] [Switch] $Movie,
        
        [Parameter(ParameterSetName = "T", Mandatory)]
        [Alias('t')] [Switch] $TV,

        [Parameter()] 
        [Alias('l')] [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {
        
        [Hashtable] $genres = @{}
        
        Write-Msg -FunctionCall -IncludeParameters

        if ( Test-IsSomething($Movie) ) {
            $label = 'Movie'
            $query = $('/genre/movie/list')
        }
        else {
            $label = 'Series/Show'
            $query = $('/genre/tv/list')
        }

        $SearchURL = @( $( $API_BASE_URI ), $query, $( '?language={0}' -f $Language ) ) -Join ''
         
        Write-Msg -p -ps -m ( 'Querying TMDB for Genres ...' )
        Write-Msg -i -il 1 -m ( 'Type: {0}'     -f $label )
        Write-Msg -d -il 1 -m ( 'Token: {0}...' -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'    -f $SearchURL )

        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            ($r.value | ConvertFrom-Json).genres | 
                ForEach-Object { 
                    $genres[($_.id.ToString())] = $_.name
                }
            $result = @{ success = $true; value = $genres }
        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            $result = @{ success = $false; message = 'No results found for query.' }
        }
        else {
            $result = $r
        }

        Write-Msg -FunctionResult -o $result

        return $result
    }
}
