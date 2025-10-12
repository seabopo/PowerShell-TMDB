Function Find-TMdb {
    <#
    .DESCRIPTION
        Searches for any Movie or TV Series/Show whose name matches the query term (and optionally, the year) 
        and returns the overview of each result.

    .OUTPUTS
        A collection of [Movie] objects with the following POPULATED properties:
            - [String] Source
            - [String] ID
            - [Bool]   Adult
            - [String] Title
            - [String] OriginalTitle
            - [String] OriginalLanguage
            - [String] Description
            - [Item[]] Genres
            - [String] ReleaseDate
            - [String] Year
            - [String] BackdropPath
            - [String] PosterPath
            - [String] BackdropURL
            - [String] PosterURL

        or a collection of [TVShow] objects with the following POPULATED properties:
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

    .PARAMETER Query
        REQUIRED. String. Alias: -q. The full or partial name of the item to search for.

    .PARAMETER Movie
        REQUIRED. Switch. Alias: -m. Search for Movies.
    
    .PARAMETER TV
        REQUIRED. Switch. Alias: -t. Search for TV Series/Shows.

    .PARAMETER Year
        OPTIONAL. String. Alias: -y. The release year of a movie or the year of the first aired episode of a TV Series.

    .PARAMETER AllYears
        OPTIONAL. String. Alias: -a. The year of any aired episode of a TV Series/Show.

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .PARAMETER IncludeAdultContent
        OPTIONAL. String. Alias: -x. Indicates whether adult content should be returned in the results. The value
        is a string and can be either 'true' for 'false'. Default Value: false

    .PARAMETER MaxResults
        OPTIONAL. Int. Alias: -r. The maximum number of results to be returned. TMDB will return a maximum of
        10,000 results for a query. If more results than MaxResults are returned an exception will be thrown.
        Default: 100

    .EXAMPLE
        Find-TMdb -Movie -Name "Aladdin" -Year "1992"

    .EXAMPLE
        Find-TMdb -m -n "Aladdin" -y "1992"

    .EXAMPLE
        Find-TMdb -TV -Name "Gilligan's Island" -Year "1967"

    .EXAMPLE
        Find-TMdb -t -n "Gilligan's Island" -y "1967"

    #>
    [OutputType([Movie[]],[TVShow[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('q')] [String] $Query,

        [Parameter(ParameterSetName = "M", Mandatory)]
        [Alias('m')] [Switch] $Movie,
        
        [Parameter(ParameterSetName = "T", Mandatory)]
        [Alias('t')] [Switch] $TV,

        [Parameter()]
        [ValidatePattern('[0-9][0-9][0-9][0-9]')]
        [ValidateLength(4,4)]
        [Alias('y')] [String] $Year = '',

        [Parameter(ParameterSetName = "T")]
        [ValidatePattern('[0-9][0-9][0-9][0-9]')]
        [ValidateLength(4,4)]
        [Alias('a')] [String] $AllYears = '',

        [Parameter()]
        [Alias('l')] [String] $Language = $((Get-Culture).Name.ToString()),

        [Parameter()]
        [ValidateSet('false','true')]
        [Alias('x')] [String] $IncludeAdultContent ='false',

        [Parameter()]
        [Alias('r')] [Int] $MaxResults = 100
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters

        if ( -not (Test-ApiTokenSet) ) { return @{ success = $false; message = $TOKEN_NOT_SET } }

        if ( Test-IsSomething($Movie) ) {
            [Movie[]] $resultItems = @()
            $label      = 'Movie'
            $searchType = $('/search/movie')
            $searchYear = $(Test-IsNothing($Year)) ? '' : '&year={0}' -f $Year
        }
        else {
            [TVShow[]] $resultItems = @()
            $label      = 'Series/Show'
            $searchType = $('/search/tv')
            if ( Test-IsSomething($AllYears) ) {
                $searchYear = '&year={0}' -f $AllYears
            }
            elseif ( Test-IsSomething($Year) ) {
                $searchYear = '&first_air_date_year={0}' -f $Year
            }
            else {
                $searchYear = ''
            }
        }

        Write-Msg -p -ps -m ( 'Querying TMDB ...' )
        Write-Msg -i -il 1 -m ( 'Type: {0}'       -f $label )
        Write-Msg -i -il 1 -m ( 'Query: {0}'      -f $Query )
        Write-Msg -i -il 1 -m ( 'Year: {0}'       -f $Year )
        Write-Msg -i -il 1 -m ( 'All Years: {0}'  -f $AllYears )
        Write-Msg -i -il 1 -m ( 'MaxResults: {0}' -f $MaxResults )
        Write-Msg -d -il 1 -m ( 'Token: {0}...'   -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        
        [Int] $page       = 0
        [Int] $maxPages   = $MaxResults / 20
        [Int] $totalPages = $null

        do {

            $page += 1
        
            $SearchURL = @(
                $( $API_BASE_URI ),
                $( $searchType ),
                $( '?query={0}' -f [System.Web.HttpUtility]::UrlEncode($Query) ),
                $( $searchYear ),
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
                    $r = @{ success = $false; message = $msg }
                    break
                }
                else {
                    ($r.value | ConvertFrom-Json).results | 
                        ForEach-Object {
                            if ( $searchType -eq $('/search/movie') ) {
                                $resultItems += $( $_ | Get-MovieFromDetails )
                            }
                            else {
                                $resultItems += $($_ | Get-TVSeriesFromDetails)
                            }
                        }
                }

            }
            else {
                $r.success = $false
            }

        } until ( -not ($r.success) -or ($page -ge $maxPages) -or ($page -ge $totalPages) )

        if ( $r.success ) {
            $result = @{ success = $true; value = $resultItems }
        }
        else {
            $result = $r
        }
        
        Write-Msg -r -m $('Results: {0} (Showing max of 3)' -f $resultItems.count) -o $($resultItems | Select-Object -First 3)

        return $result
    }
}
