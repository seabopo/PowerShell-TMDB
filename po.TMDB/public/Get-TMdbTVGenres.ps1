Function Get-TMdbTVGenres {
    <#
    .DESCRIPTION
        Gets the list of available TV Genres.

    .OUTPUTS
        An [Hashtable] containing the ID and Name of each TV Series/Show Genre.
            @{
                "16": "Animation",
                "80": "Crime",
                "35": "Comedy",
                "10751": "Family",
                "10759": "Action & Adventure",
                "10763": "News",
                "99": "Documentary",
                "18": "Drama",
                "10767": "Talk",
                "37": "Western",
                "10762": "Kids",
                "9648": "Mystery",
                "10764": "Reality",
                "10768": "War & Politics",
                "10766": "Soap",
                "10765": "Sci-Fi & Fantasy"
            }

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbTVGenres

    .EXAMPLE
        Get-TMdbTVGenres -Language 'en-US'

    .EXAMPLE
        Get-TMdbTVGenres -l 'en-US'

    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [Parameter()] [Alias('l')] [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {
        
        [Hashtable] $genres = @{}
        
        Write-Msg -FunctionCall -IncludeParameters

        $SearchURL = @( $( $API_BASE_URI ), $( '/genre/tv/list' ), $( '?language={0}' -f $Language ) ) -Join ''
         
        Write-Msg -p -ps -m ( 'Querying TMDB for TV Genres ...' )
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
