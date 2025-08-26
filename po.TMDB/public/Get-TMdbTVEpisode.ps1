Function Get-TMdbTVEpisode {
    <#
    .DESCRIPTION
        Gets the details of a single TV Episode.

    .OUTPUTS
        A single [TVEpisode] object with the following properties:
            - [String]   Source
            - [String]   ID
            - [String]   SeasonID
            - [String]   ShowID
            - [int32]    Season
            - [int32]    Number
            - [String]   Type
            - [String]   Title
            - [String]   Description (255 characters or less)
            - [String]   LongDescription (More than 255 characters)
            - [Credit[]] Cast
            - [Credit[]] Crew
            - [Credit[]] Guests
            - [String]   ProductionCode
            - [String]   AirDate
            - [String]   Network
            - [int32]    Runtime
            - [String]   StillPath
            - [String]   StillURL
            - [Item[]]   ExternalIDs
            - [Image[]]  Images

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -i, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        REQUIRED. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        REQUIRED. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .PARAMETER IncludeEpisodeCastCredits
        OPTIONAL. Switch. Alias: -cce. The TMDB Episode details include the credits for crew members and guest 
        stars but do not include the cast credits, which is a separate TMDB query. Use this switch if you want to 
        include the cast credits in your episode details.

    .PARAMETER IncludeEpisodeImages
        OPTIONAL. Switch. Alias: -ie. TMDB includes a single still image representing the episode in the episode 
        details. However, episodes may have multiple images available to select from. To include links to all of
        the images include this parameter.

    .PARAMETER IncludeEpisodeExternalIDs
        OPTIONAL. Switch. Alias: -xe. TMDB includes the IDs used by other media databases (IMDB, Freebase, TVDB, 
        TVRage and Wikidata) for many of the the entries in it's catalog. Use this switch to include the IDs 
        of those entries (if they exist).

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeCastCredits

    .EXAMPLE
        Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeImages

    .EXAMPLE
        Get-TMdbTVEpisode -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeExternalIDs

    .EXAMPLE
        Get-TMdbTVEpisode -ShowID 615 -SeasonNumber 1 -EpisodeNumber 1 -IncludeEpisodeCastCredits

    .EXAMPLE
        Get-TMdbTVEpisode -i 615 -s 1 -e 1 -cce -ie -xe

    #>
    [OutputType([TVEpisode])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i','ShowID')] [String] $SeriesID,
        [Parameter(Mandatory)] [Alias('s')]          [Int]    $SeasonNumber,
        [Parameter(Mandatory)] [Alias('e')]          [Int]    $EpisodeNumber,
        [Parameter()]          [Alias('cce')]        [Switch] $IncludeEpisodeCastCredits,
        [Parameter()]          [Alias('ie')]         [Switch] $IncludeEpisodeImages,
        [Parameter()]          [Alias('xe')]         [Switch] $IncludeEpisodeExternalIDs,
        [Parameter()]          [Alias('l')]          [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/tv/{0}'       -f $SeriesID ),
            $( '/season/{0}'   -f $SeasonNumber ),
            $( '/episode/{0}'  -f $EpisodeNumber ),
            $( '?language={0}' -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for TV Episode Details ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}'  -f $SeriesID )
        Write-Msg -i -il 1 -m ( 'Season Number: {0}'   -f $SeasonNumber )
        Write-Msg -i -il 1 -m ( 'Episode Number: {0}'  -f $EpisodeNumber )
        Write-Msg -d -il 1 -m ( 'Token: {0}...'        -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'           -f $SearchURL )

        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $e = ($r.value | ConvertFrom-Json)

            if ( -not ([String]::IsNullOrEmpty($e)) ) {
                
                $episode = $( $e | Get-TVEpisodeFromDetails )

                if ( [String]::IsNullOrEmpty($episode.ShowID) ) { $episode.ShowID = $SeriesID }

                if ( $IncludeEpisodeCastCredits ) {
                    $c = Get-TMdbTVCredits -i $SeriesID -s $SeasonNumber -e $EpisodeNumber
                    if ( $c.success ) {
                        $episode.Cast = $c.value.cast
                    }
                }

                if ( $IncludeEpisodeImages ) {
                    $i = Get-TMdbTVImages -i $SeriesID -s $SeasonNumber -e $EpisodeNumber
                    if ( $i.success ) {
                        $episode.Images = $i.value
                    }
                }

                if ( $IncludeEpisodeExternalIDs ) {
                    $x = Get-TMdbTVExternalIDs -i $SeriesID -s $SeasonNumber -e $EpisodeNumber
                    if ( $x.success ) {
                        $episode.ExternalIDs = $x.value
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

        Write-Msg -FunctionResult -Object $episode -MaxRecursionDepth 5

        return @{ success = $r.success; value = $episode }
    }
}
