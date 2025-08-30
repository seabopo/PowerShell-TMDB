Function Get-TMdbTVImages {
    <#
    .DESCRIPTION
        Gets the poster, background, logo or still images of a TV Show, Season or Episode.

    .OUTPUTS
        A collection of [Image] objects. Each object contains the following properties:
            - [String]  Type        : "poster" | "background" | "still" | "image"
            - [Decimal] AspectRatio : 0.667,
            - [Int]     Height      : 3000
            - [Int]     Width       : 2000
            - [String]  Language    : "en"
            - [String]  Path        : "/7bRHBrmSn5QLY1UJ32v4jeSoKzP.jpg"
            - [String]  URL         : "https://media.themoviedb.org/t/p/original/7bRHBrmSn5QLY1UJ32v4jeSoKzP.jpg"

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -i, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        OPTIONAL. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        OPTIONAL. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbTVImages -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbTVImages -SeriesID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbTVImages -ShowID 615

    .EXAMPLE
        Get-TMdbTVImages -i 615 -s 1 -e 1

    #>
    [OutputType([Image[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i','ShowID')] [String] $SeriesID,
        [Parameter()]          [Alias('s')]          [System.Nullable[int]] $SeasonNumber,
        [Parameter()]          [Alias('e')]          [System.Nullable[int]] $EpisodeNumber,
        [Parameter()]          [Alias('l')]          [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        $season  = ( $null -eq $SeasonNumber  ) ? $null : $( '/season/{0}'  -f $SeasonNumber )
        $episode = ( $null -eq $EpisodeNumber ) ? $null : $( '/episode/{0}' -f $EpisodeNumber )

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/tv/{0}' -f $SeriesID ),
            $( $season ),
            $( $episode ),
            $( '/images' )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for TV Images ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}'  -f $SeriesID )
        if ( $SeasonNumber ) {
            Write-Msg -i -il 1 -m ( 'Season Number: {0}'   -f $SeasonNumber )
        }
        if ( $EpisodeNumber ) {
            Write-Msg -i -il 1 -m ( 'Episode Number: {0}'  -f $EpisodeNumber )
        }
        Write-Msg -d -il 1 -m ( 'Token: {0}...'        -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'           -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $i = ($r.value | ConvertFrom-Json)
            if ( Test-IsSomething($i) ) {
                [Image[]] $images = @()
                $types = @('logos','posters','backdrops','stills')
                $l = $($Language.Split('-')[0])
                foreach ( $t in $types ) {
                    if ( $null -ne $($i."$($t)") ) {
                        $images += $( $($i."$($t)") | Get-ImageFromDetails -t $t | 
                                                      Where-Object { $_.Language -in @($l,'',$null) } )
                    }
                }
            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            Write-Msg -e -ps -ds -m $('No results found for query.')
        }
        else {
            Write-Msg -e -ps -ds -m $($r.message)
        }

        Write-Msg -FunctionResult -Object $images

        return @{ success = $r.success; value = $images }
    }
}
