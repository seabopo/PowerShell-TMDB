Function Get-TMdbExternalIDs {
    <#
    .DESCRIPTION
        Creates a collection of object references to external media databases for a Movie, TV Show, TV Season 
        or TV Episode.

    .OUTPUTS
        A collection of [Item] objects. Each Item has the following properties:
            - [String] Name
            - [String] ID

    .PARAMETER MovieID
        REQUIRED. String. Alias: -m. The Movie ID. Example: 18

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -t, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        OPTIONAL. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        OPTIONAL. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .EXAMPLE
        Get-TMdbExternalIDs -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbExternalIDs -SeriesID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbExternalIDs -ShowID 615

    .EXAMPLE
        Get-TMdbExternalIDs -t 615 -s 1 -e 1

    #>
    [OutputType([Item[]])]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = "M", Mandatory)] 
        [Alias('m')]          [String] $MovieID,

        [Parameter(ParameterSetName = "T", Mandatory)] 
        [Alias('t','ShowID')] [String] $SeriesID,

        [Parameter(ParameterSetName = "T")]
        [Alias('s')]          [System.Nullable[int]] $SeasonNumber,
        
        [Parameter(ParameterSetName = "T")]
        [Alias('e')]          [System.Nullable[int]] $EpisodeNumber
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

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

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( $query ),
            $( '/external_ids' )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for External IDs ...' )
        Write-Msg -i -il 1 -m ( '{0} ID: {1}'             -f $label, $itemID )
        if ( $SeasonNumber ) {
            Write-Msg -i -il 1 -m ( 'Season Number: {0}'  -f $SeasonNumber )
        }
        if ( $EpisodeNumber ) {
            Write-Msg -i -il 1 -m ( 'Episode Number: {0}'  -f $EpisodeNumber )
        }
        Write-Msg -d -il 1 -m ( 'Token: {0}...'            -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'               -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $x = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($x) ) {

                [Item[]] $externalIDs = @()

                if ( Test-IsSomething($x.id) ) {
                    $externalIDs += [Item]::new(@{ name = 'tmdb'; id = $x.id })
                }

                if ( Test-IsSomething($x.imdb_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'imdb'; id = $x.imdb_id })
                }

                if ( Test-IsSomething($x.freebase_mid) ) {
                    $externalIDs += [Item]::new(@{ name = 'freebase_mid'; id = $x.freebase_mid })
                }

                if ( Test-IsSomething($x.freebase_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'freebase'; id = $x.freebase_id })
                }

                if ( Test-IsSomething($x.tvdb_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'tvdb'; id = $x.tvdb_id })
                }

                if ( Test-IsSomething($x.tvrage_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'tvrage'; id = $x.tvrage_id })
                }

                if ( Test-IsSomething($x.wikidata_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'wikidata'; id = $x.wikidata_id })
                }

                $result = @{ success = $true; value = $externalIDs }

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

        Write-Msg -FunctionResult -Object $result

        return $result
    }
}
