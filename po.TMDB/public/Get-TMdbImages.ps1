Function Get-TMdbImages {
    <#
    .DESCRIPTION
        Gets the poster, background, logo or still images of a Movie, TV Show, TV Season or TV Episode.

    .OUTPUTS
        A collection of [Image] objects. Each object contains the following properties:
            - [String]  Type        : "poster" | "background" | "still" | "image"
            - [Decimal] AspectRatio : 0.667,
            - [Int]     Height      : 3000
            - [Int]     Width       : 2000
            - [String]  Language    : "en"
            - [String]  Path        : "/7bRHBrmSn5QLY1UJ32v4jeSoKzP.jpg"
            - [String]  URL         : "https://media.themoviedb.org/t/p/original/7bRHBrmSn5QLY1UJ32v4jeSoKzP.jpg"

    .PARAMETER MovieID
        REQUIRED. String. Alias: -m. The Movie ID. Example: 18

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -t, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        OPTIONAL. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        OPTIONAL. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .PARAMETER Languages
        OPTIONAL. String. Alias: -l. The desired target language(s) of the query. The value defaults to the user's 
        operating system settings. Example: 'en' | @('en','es')

        NOTE: This parameter uses only the basic (2-letter) language codes, and does not use the language/culture
              codes that all the other functions use. This is due to the TMDBs api differences for image calls.

    .PARAMETER AllLanguages
        OPTIONAL. Switch. Alias: -a. Return all images no matter what the language.

    .EXAMPLE
        Get-TMdbImages -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbImages -SeriesID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbImages -ShowID 615

    .EXAMPLE
        Get-TMdbImages -MovieID 18

    .EXAMPLE
        Get-TMdbImages -t 615 -s 1 -e 1

    .EXAMPLE
        Get-TMdbImages -m 18

    #>
    [OutputType([Image[]])]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = "M", Mandatory)] 
        [Alias('m')]          [String] $MovieID,

        [Parameter(ParameterSetName = "T", Mandatory)] 
        [Alias('t','ShowID')] [String] $SeriesID,

        [Parameter(ParameterSetName = "T")]
        [Alias('s')]          [System.Nullable[int]] $SeasonNumber,
        
        [Parameter(ParameterSetName = "T")]
        [Alias('e')]          [System.Nullable[int]] $EpisodeNumber,
        
        [Parameter()]
        [Alias('l')]          [String[]] $Languages = @($((Get-Culture).Name.ToString().Split('-')[0])),

        [Parameter()]
        [Alias('a')]          [Switch] $AllLanguages
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        if ( -not (Test-ApiTokenSet) ) { return @{ success = $false; message = $TOKEN_NOT_SET } }

        if ( Test-IsSomething($MovieID) ) {
            $label  = 'Movie'
            $itemID = $MovieID
            $query  = $('/movie/{0}' -f $MovieID)
        }
        else {
            $label   = 'Series/Show'
            $itemID  = $SeriesID
            $show    = $('/tv/{0}' -f $SeriesID)
            $season  = ( $null -eq $SeasonNumber  ) ? $null : $( '/season/{0}'  -f $SeasonNumber )
            $episode = ( $null -eq $EpisodeNumber ) ? $null : $( '/episode/{0}' -f $EpisodeNumber )
            $query   = @( $show, $season, $episode ) -Join ''
        }

        if ( $AllLanguages ) {
            $language  = $null
        }
        else {
            $language = '?include_image_language={0},null' -f $($Languages -Join ',')
        }

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( $query ),
            $( '/images' ),
            $( $language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for Images ...' )
        Write-Msg -i -il 1 -m ( '{0} ID: {1}'              -f $label, $itemID )
        if ( $SeasonNumber ) {
            Write-Msg -i -il 1 -m ( 'Season Number: {0}'   -f $SeasonNumber )
        }
        if ( $EpisodeNumber ) {
            Write-Msg -i -il 1 -m ( 'Episode Number: {0}'  -f $EpisodeNumber )
        }
        Write-Msg -d -il 1 -m ( 'Token: {0}...'            -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'               -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $i = ($r.value | ConvertFrom-Json)
            if ( Test-IsSomething($i) ) {
                [Image[]] $images = @()
                $types = @('logos','posters','backdrops','stills')
                foreach ( $t in $types ) {
                    if ( $null -ne $($i."$($t)") ) {
                        $images += $( $($i."$($t)") | Get-ImageFromDetails -t $t )
                    }
                }
                $result = @{ success = $true; value = $images }
            }
            else {
                $result = @{ success = $true; value = $null }
            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            $result = @{ success = $false; message = 'No results found for query.' }
        }
        else {
            $result = $r
        }

        Write-Msg -FunctionResult -Object $images

        return $result
    }
}
