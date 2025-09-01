Function Find-TMdbTVSeries {
    <#
    .DESCRIPTION
        Searches for any TV Series/Show matching the Name (and optionally, the year) and returns the show/series 
        overview for each result.

    .OUTPUTS
        An collection of [TVShow] objects with the following POPULATED properties:
            - [String]   Source
            - [String]   ID
            - [String]   Name
            - [String]   OriginalName
            - [String]   Description
            - [String[]] Country
            - [Item[]]   Genres
            - [String]   PosterPath
            - [String]   BackdropPath
            - [String]   Year
            - [String]   FirstAirDate

    .PARAMETER Name
        REQUIRED. String. Alias: -n. The name of the Series/Show to search for.

    .PARAMETER Year
        OPTIONAL. String. Alias: -y. The year of the first aired episode of the TV Series/Show.

    .PARAMETER AllYears
        OPTIONAL. String. Alias: -a. The year of the first aired episode of the TV Series/Show, or the year of any 
        aired episode of the TV Series/Show.

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .PARAMETER IncludeAdultContent
        OPTIONAL. String. Alias: -x. Indicates whether adult content should be returned in the results. The value
        is a string and can be either 'true' for 'false'. Default Value: false

    .PARAMETER MaxResults
        OPTIONAL. Int. Alias: -m. The maximum number of results to be returned. TMDB will return a maximum of
        10,000 results for a query. If more results than MaxResults are returned an exception will be thrown.
        Default: 100

    .EXAMPLE
        Find-TMdbTVSeries -Name "Gilligan's Island" -Year "1967"

    .EXAMPLE
        Find-TMdbTVShows -n "Gilligan's Island" -y "1967"

    #>
    [Alias('Find-TMdbTVShows')]
    [OutputType([TVShow[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('n')] [String] $Name,

        [Parameter()]
        [ValidatePattern('[0-9][0-9][0-9][0-9]')]
        [ValidateLength(4,4)]
        [Alias('y')] [String] $Year = '',

        [Parameter()]
        [ValidatePattern('[0-9][0-9][0-9][0-9]')]
        [ValidateLength(4,4)]
        [Alias('a')] [String] $AllYears = '',

        [Parameter()]
        [Alias('l')] [String] $Language = $((Get-Culture).Name.ToString()),

        [Parameter()]
        [ValidateSet('false','true')]
        [Alias('x')] [String] $IncludeAdultContent ='false',

        [Parameter()]
        [Alias('m')] [Int] $MaxResults = 100
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters

        Write-Msg -p -ps -m ( 'Querying TMDB for Series/Show Names ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show Name: {0}' -f $Name )
        Write-Msg -i -il 1 -m ( 'Year: {0}'             -f $Year )
        Write-Msg -i -il 1 -m ( 'MaxResults: {0}'       -f $Year )
        Write-Msg -d -il 1 -m ( 'Token: {0}...'         -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        
        [TVShow[]] $shows      = @()
        [Int]      $page       = 0
        [Int]      $maxPages   = $MaxResults / 20
        [Int]      $totalPages = $null

        do {

            $page += 1
        
            $SearchURL = @(
                $( $API_BASE_URI ),
                $( '/search/tv' ),
                $( '?query={0}' -f [System.Web.HttpUtility]::UrlEncode($Name) ),
                $( $(Test-IsNothing($Year)) ? '' : '&year={0}' -f $Year ),
                $( '&include_adult={0}' -f $IncludeAdultContent ),
                $( '&language={0}' -f $Language ),
                $( '&page={0}' -f $page )
            ) -Join ''
         
            Write-Msg -d -il 1 -m ( 'Query: {0}' -f $SearchURL )

            $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

            if ( $r.success -and $r.statusCode -eq 200 ) {
                
                $results      = ($r.value | ConvertFrom-Json)
                $totalPages   = $results.total_pages
                $totalResults = $results.total_results

                if ( $totalResults -gt $MaxResults ) { 
                    $msg = @(
                        $('{0}::Maximum results exceeded. ' -f $MyInvocation.InvocationName),
                        $('{0} results were returned by TMDB. ' -f $totalResults),
                        $('MaxResults is currently set to {0} results. ' -f $MaxResults)
                    ) -Join ''
                    Throw ( $msg )
                }

                [TVShow[]] $shows = ($r.value | ConvertFrom-Json).results | ForEach-Object { 
                                        $_ | Get-TVSeriesFromSearchResults
                                    }

            }
            else {
                Write-Msg -e -ps -ds -m $($r.message)
                $r.success = $false
            }

        } until ( ($page -ge $maxPages) -or ($page -ge $totalPages) )

        Write-Msg -r -m $('Results: {0} (Showing max of 3)' -f $shows.count) -o $($shows | Select-Object -First 3)

        return @{ success = $r.success; value = $shows }
    }
}
