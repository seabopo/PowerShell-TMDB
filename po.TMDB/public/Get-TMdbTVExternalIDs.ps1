Function Get-TMdbTVExternalIDs {
    <#
    .DESCRIPTION
        Creates a collection of object references to external media databases for a TV Show, Season or Episode.

    .OUTPUTS
        A collection of [Item] objects. Each Item has the following properties:
            - [String] Name
            - [String] ID

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -t, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        OPTIONAL. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        OPTIONAL. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .EXAMPLE
        Get-TMdbTVExternalIDs -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbTVExternalIDs -SeriesID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbTVExternalIDs -ShowID 615

    .EXAMPLE
        Get-TMdbTVExternalIDs -t 615 -s 1 -e 1

    #>
    [OutputType([Item[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('t','ShowID')] [String] $SeriesID,
        [Parameter()]          [Alias('s')]          [System.Nullable[int]] $SeasonNumber,
        [Parameter()]          [Alias('e')]          [System.Nullable[int]] $EpisodeNumber
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
            $( '/external_ids' )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for External IDs ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}' -f $SeriesID )
        if ( $SeasonNumber ) {
            Write-Msg -i -il 1 -m ( 'Season Number: {0}' -f $SeasonNumber )
        }
        if ( $EpisodeNumber ) {
            Write-Msg -i -il 1 -m ( 'Episode Number: {0}' -f $EpisodeNumber )
        }
        Write-Msg -d -il 1 -m ( 'Token: {0}...' -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'    -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $e = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($e) ) {

                [Item[]] $externalIDs = @()

                if ( Test-IsSomething($e.id) ) {
                    $externalIDs += [Item]::new(@{ name = 'tmdb'; id = $e.id })
                }

                if ( Test-IsSomething($e.imdb_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'imdb'; id = $e.imdb_id })
                }

                if ( Test-IsSomething($e.freebase_mid) ) {
                    $externalIDs += [Item]::new(@{ name = 'freebase_mid'; id = $e.freebase_mid })
                }

                if ( Test-IsSomething($e.freebase_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'freebase'; id = $e.freebase_id })
                }

                if ( Test-IsSomething($e.tvdb_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'tvdb'; id = $e.tvdb_id })
                }

                if ( Test-IsSomething($e.tvrage_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'tvrage'; id = $e.tvrage_id })
                }

                if ( Test-IsSomething($e.wikidata_id) ) {
                    $externalIDs += [Item]::new(@{ name = 'wikidata'; id = $e.wikidata_id })
                }

            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            Write-Msg -e -ps -ds -m $('No results found for query.')
        }
        else {
            Write-Msg -e -ps -ds -m $($r.message)
        }

        Write-Msg -FunctionResult -Object $externalIDs

        return @{ success = $r.success; value = $externalIDs }
    }
}
