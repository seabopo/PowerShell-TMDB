Function Get-TMdbContentRatings {
    <#
    .DESCRIPTION
        Gets the content ratings of a Movie or TV Series/Show. By default only the content rating matching the 
        country set in the users operating system will be returned. Optionally, the ratings for all countries 
        can be returned.

    .OUTPUTS
        A collection of [ContentRating] objects, each with the following properties:
            - [String]   Country     : "US"
            - [String]   Rating      : "TV-14"
            - [String[]] Descriptors : ["L","V"]

    .PARAMETER MovieID
        REQUIRED. String. Alias: -m. The Movie ID. Example: 18

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -t, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER Country
        OPTIONAL. String. Alias: -c. The desired target country of the query. The value defaults to the 
        user's operating system settings. Example: US

    .PARAMETER AllRatings
        OPTIONAL. Switch. Alias -a. Return the ratings from all countries and not just the rating matching 
        the country setting of the user's operating system.

    .EXAMPLE
        Get-TMdbContentRatings -SeriesID 615 -Country 'US'

    .EXAMPLE
        Get-TMdbContentRatings -ShowID 615 -AllRatings

    .EXAMPLE
        Get-TMdbContentRatings -MovieID 18 -Country 'US'

    .EXAMPLE
        Get-TMdbContentRatings -t 615 -a

    .EXAMPLE
        Get-TMdbContentRatings -m 18

    #>
    [OutputType([ContentRating[]])]
    [CmdletBinding()]
    param (

        [Parameter(ParameterSetName = "M", Mandatory)] 
        [Alias('m')]          [String] $MovieID,

        [Parameter(ParameterSetName = "T", Mandatory)] 
        [Alias('t','ShowID')] [String] $SeriesID,

        [Parameter()]
        [Alias('c')]          [String] $Country = $((Get-Culture).Name.ToString().Split('-')[1]),

        [Parameter()]
        [Alias('a')]          [Switch] $AllRatings
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        if ( Test-IsSomething($MovieID) ) {
            $label  = 'Movie'
            $itemID = $MovieID
            $query  = $('/movie/{0}/release_dates' -f $MovieID)
        }
        else {
            $label = 'Series/Show'
            $itemID = $SeriesID
            $query = $('/tv/{0}/content_ratings' -f $SeriesID)
        }

        $SearchURL = @( $API_BASE_URI, $query ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for Content Ratings ...' )
        Write-Msg -i -il 1 -m ( '{0} ID: {1}'   -f $label, $itemID )
        Write-Msg -d -il 1 -m ( 'Token: {0}...' -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'    -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $rv = ($r.value | ConvertFrom-Json).results

            if ( Test-IsSomething($rv) ) {

                if ( (Test-IsSomething($MovieID)) -and $AllRatings ) {
                    $ratings = $( $rv | Get-MovieContentRatingsFromDetails )
                }
                elseif ( Test-IsSomething($MovieID) ) {
                    $ratings = $( $rv | Where-Object { $_.iso_3166_1 -eq $country } | 
                                        Get-MovieContentRatingsFromDetails )
                }
                elseif ( (Test-IsSomething($SeriesID)) -and $AllRatings ) {
                    $ratings = $( $rv | Get-TVContentRatingFromDetails )
                }
                elseif ( Test-IsSomething($SeriesID)) {
                    $ratings = $( $rv | Where-Object { $_.iso_3166_1 -eq $country } | 
                                        Get-TVContentRatingFromDetails )
                }
                else {
                    $ratings = $null
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
