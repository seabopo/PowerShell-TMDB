Function Get-TMdbMovieContentRatings {
    <#
    .DESCRIPTION
        Gets the content ratings of a Movie. By default only the content rating matching the country set in the
        users operating system will be returned. Optionally, the ratings for all countries can be returned.

    .OUTPUTS
        A collection of [ContentRating] objects, each with the following properties:
            - [String]   Country     : "US"
            - [String]   Rating      : "PG-13"
            - [String[]] Descriptors : ["L","V"]

    .PARAMETER MovieID
        REQUIRED. String. Alias: -i. The Movie ID. Example: 18

    .PARAMETER AllRatings
        OPTIONAL. Switch. Alias -a. Return the ratings from all countries for a Movie, and not just the 
        rating matching the country setting of the user's operating system.

    .EXAMPLE
        Get-TMdbMovieReleaseDates -MovieID 18

    .EXAMPLE
        Get-TMdbMovieReleaseDates -i 18 -img

    #>
    [OutputType([Movie])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i')] [String] $MovieID,
        [Parameter()]          [Alias('a')] [Switch] $AllRatings,
        [Parameter()]          [Alias('c')] [String] $Country = $((Get-Culture).Name.ToString().Split('-')[1])
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/movie/{0}'     -f $MovieID ),
            $( '/release_dates' ),
            $( '?language={0}'  -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for Movie Release Dates and Content Ratings ...' )
        Write-Msg -i -il 1 -m ( 'Movie ID: {0}' -f $MovieID )
        Write-Msg -d -il 1 -m ( 'Token: {0}...' -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'    -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $rd = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($rd) ) {
                
                $ratings = $( $rd.results | Get-MovieContentRatingsFromDetails )
                
                if ( -not $AllRatings ) {
                    $ratings = $ratings | Where-Object { $_.Country -eq $Country }
                }

            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            Write-Msg -e -ps -ds -m $('No results found for query.')
        }
        else {
            Write-Msg -e -ps -ds -m $($r.message)
        }

        Write-Msg -FunctionResult -Object $ratings

        return @{ success = $r.success; value = $ratings }
    }
}
