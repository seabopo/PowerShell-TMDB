Function Get-TMdbTVSeason {
    <#
    .DESCRIPTION
        Gets the details of a single TV Season, which includes the data for all episodes.

    .OUTPUTS
        A single [TVSeason] object with the following properties:
            - [String]      Source
            - [String]      ID
            - [String]      ShowID
            - [int32]       Number
            - [String]      Name
            - [String]      Description
            - [Credit[]]    Cast
            - [Credit[]]    Crew
            - [String]      Network
            - [String]      Year
            - [String]      FirstAirDate
            - [String]      LastAirDate
            - [int32]       TotalEpisodes
            - [String]      PosterPath
            - [String]      BackdropPath
            - [String]      PosterURL
            - [String]      BackdropURL
            - [TVEpisode[]] Episodes
            - [Item[]]      ExternalIDs
            - [Image[]]     Images

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -i, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        REQUIRED. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER IncludeSeasonCastCredits
        OPTIONAL. Switch. Alias: -ccs. The TMDB Season details do not include the credits for cast or crew 
        members, which is a separate TMDB query. Use this switch to include the cast and crew credits 
        in the season details.

    .PARAMETER IncludeSeasonImages
        OPTIONAL. Switch. Alias: -imgs. TMDB includes a poster image representing the season in the season 
        details. However, seasons may have multiple images available to select from. To include links to all of
        the images include this parameter.

    .PARAMETER IncludeSeasonExternalIDs
        OPTIONAL. Switch. Alias: -xids. TMDB includes the IDs used by other media databases (IMDB, Freebase, TVDB, 
        TVRage and Wikidata) for many of the the entries in it's catalog. Use this switch to include the IDs 
        of those entries (if they exist) in the season data.

    .PARAMETER IncludeEpisodeCastCredits
        OPTIONAL. Switch. Alias: -cce. The TMDB Episode details include the credits for crew members and guest 
        stars but do not include the cast credits, which is a separate TMDB query. Use this switch to 
        include the cast credits in the episode details.

        Please note that this parameter is mutually exclusive with the IncludeSeasonCastCreditsForEpisodes 
        parameter.

    .PARAMETER IncludeEpisodeImages
        OPTIONAL. Switch. Alias: -imge. TMDB includes a single still image representing the episode in the episode 
        details. However, episodes may have multiple images available to select from. To include links to all of
        the images include this parameter.

    .PARAMETER IncludeEpisodeExternalIDs
        OPTIONAL. Switch. Alias: -xide. TMDB includes the IDs used by other media databases (IMDB, Freebase, TVDB, 
        TVRage and Wikidata) for many of the the entries in it's catalog. Use this switch to include the IDs 
        of those entries (if they exist) in the episode data.

    .PARAMETER IncludeSeasonCastCreditsForEpisodes
        OPTIONAL. Switch. Alias: -escc. The TMDB Season details include the episode data. The episode data includes
        crew and guest star credits, but does not include cast credits, which is a separate TMDB query. Use this 
        switch if you want to apply the TV Series/Show season cast credits to each episode in that Season. 
        
        Please note that this parameter is mutually exclusive with the IncludeEpisodeCastCreditsForEpisodes 
        parameter.

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbTVSeason -ShowID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbTVSeason -ShowID 615 -SeasonNumber 1 -IncludeSeasonCastCredits -IncludeSeasonImages

    .EXAMPLE
        Get-TMdbTVSeason -ShowID 615 -SeasonNumber 1 -IncludeEpisodeCastCredits -IncludeEpisodeImages

    .EXAMPLE
        Get-TMdbTVSeason -i 615 -s 1 -ccs -imgs -xids -ccse -imge -xide

    #>
    [OutputType([TVSeason])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i','ShowID')] [String] $SeriesID,
        [Parameter(Mandatory)] [Alias('s')]          [Int]    $SeasonNumber,
        [Parameter()]          [Alias('ccs')]        [Switch] $IncludeSeasonCastCredits,
        [Parameter()]          [Alias('imgs')]       [Switch] $IncludeSeasonImages,
        [Parameter()]          [Alias('xids')]       [Switch] $IncludeSeasonExternalIDs,
        [Parameter()]          [Alias('cce')]        [Switch] $IncludeEpisodeCastCredits,
        [Parameter()]          [Alias('imge')]       [Switch] $IncludeEpisodeImages,
        [Parameter()]          [Alias('xide')]       [Switch] $IncludeEpisodeExternalIDs,
        [Parameter()]          [Alias('ccse')]       [Switch] $IncludeSeasonCastCreditsForEpisodes,
        [Parameter()]          [Alias('l')]          [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        if ( $IncludeSeasonCastCreditsForEpisodes -and $IncludeEpisodeCastCredits ) {
            Throw $('The IncludeSeasonCastCreditsForEpisodes and IncludeEpisodeCastCredits parameters
                     are mutually exclusive. Please use only one of these parameters at a time.')
        }

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/tv/{0}'       -f $SeriesID ),
            $( '/season/{0}'   -f $SeasonNumber ),
            $( '?language={0}' -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for TV Season Details ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}'  -f $SeriesID )
        Write-Msg -i -il 1 -m ( 'Season Number: {0}'   -f $SeasonNumber )
        Write-Msg -d -il 1 -m ( 'Token: {0}...'        -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'           -f $SearchURL )

        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $s = ($r.value | ConvertFrom-Json)

            if ( -not ([String]::IsNullOrEmpty($s)) ) {

                $season = $( $s | Get-TVSeasonFromDetails )

                if ( [String]::IsNullOrEmpty($season.ShowID) ) {
                    $season.ShowID = $SeriesID
                }

                if ( $IncludeSeasonCastCredits -or $IncludeSeasonCastCreditsForEpisodes ) {
                    $c = Get-TMdbTVCredits -i $SeriesID -s $SeasonNumber
                    if ( $c.success ) {
                        if ( $IncludeSeasonCastCredits ) {
                            $season.Cast = $c.value.cast
                            $season.Crew = $c.value.crew
                        }
                        if ( $IncludeSeasonCastCreditsForEpisodes ) {
                            $season.Episodes | ForEach-Object {
                                if ( $c.success ) {
                                    $_.Cast = $c.value.cast
                                }
                            }
                        }
                    }
                }

                if ( $IncludeSeasonImages ) {
                    $i = Get-TMdbTVImages -i $SeriesID -s $SeasonNumber
                    if ( $i.success ) {
                        $season.Images = $i.value
                    }
                }

               if ( $IncludeSeasonExternalIDs ) {
                    $x = Get-TMdbTVExternalIDs -i $SeriesID -s $SeasonNumber
                    if ( $x.success ) {
                        $season.ExternalIDs = $x.value
                    }
                }

                if ( $IncludeEpisodeCastCredits ) {
                    $season.Episodes | ForEach-Object {
                        $c = Get-TMdbTVCredits -i $_.ShowID -s $_.Season -e $_.Number
                        if ( $c.success ) {
                            $_.Cast = $c.value.cast
                        }
                    }
                }

                if ( $IncludeEpisodeImages ) {
                    $season.Episodes | ForEach-Object {
                        $i = Get-TMdbTVImages -i $_.ShowID -s $_.Season -e $_.Number
                        if ( $i.success ) {
                            $_.Images = $i.value
                        }
                    }
                }

                if ( $IncludeEpisodeExternalIDs ) {
                    $season.Episodes | ForEach-Object {
                        $x = Get-TMdbTVExternalIDs -i $_.ShowID -s $_.Season -e $_.Number
                        if ( $x.success ) {
                            $_.ExternalIDs = $x.value
                        }
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

        Write-Msg -FunctionResult -Object $season -MaxRecursionDepth 5

        return @{ success = $r.success; value = $season }
    }
}
