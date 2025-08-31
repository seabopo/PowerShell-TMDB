Function Get-TMdbTVContentRatings {
    <#
    .DESCRIPTION
        Gets the content ratings of a TV Series/Show. By default only the content rating matching the country set 
        in the users operating system will be returned. Optionally, the ratings for all countries can be returned.

    .OUTPUTS
        A collection of [ContentRating] objects, each with the following properties:
            - [String]   Country     : "US"
            - [String]   Rating      : "TV-14"
            - [String[]] Descriptors : ["L","V"]

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -i, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER Country
        OPTIONAL. String. Alias: -l. The desired target country of the query. The value defaults to the user's 
        operating system settings. Example: US

    .PARAMETER AllRatings
        OPTIONAL. Switch. Alias -a. Return the ratings from all countries for a Series/Show, and not just the 
        rating matching the culture/language setting of the user's operating system.

    .EXAMPLE
        Get-TMdbTVContentRatings -SeriesID 615 -AllRatings

    .EXAMPLE
        Get-TMdbTVContentRatings -ShowID 615

    .EXAMPLE
        Get-TMdbTVContentRatings -i 615 -a

    #>
    [OutputType([ContentRating[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i','ShowID')] [String] $SeriesID,
        [Parameter()]          [Alias('a')]          [Switch] $AllRatings,
        [Parameter()]          [Alias('c')]          [String] $Country = $((Get-Culture).Name.ToString().Split('-')[1])
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/tv/{0}' -f $SeriesID ),
            $( '/content_ratings' )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for TV Series Ratings ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}' -f $SeriesID )
        Write-Msg -d -il 1 -m ( 'Token: {0}...'       -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'          -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $v = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($v) ) {
                
                $ratings = $v.results | Get-TVContentRatingFromDetails

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
