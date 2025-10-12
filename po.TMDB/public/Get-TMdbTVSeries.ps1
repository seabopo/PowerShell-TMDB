Function Get-TMdbTVSeries {
    <#
    .DESCRIPTION
        Gets the details of a single TV Series/Show.

    .OUTPUTS
        A single [TVShow] object with the following properties:
            - [String]          Source
            - [String]          ID
            - [String]          Name
            - [String]          OriginalName
            - [String]          Description
            - [String]          Rating
            - [ContentRating[]] Ratings
            - [String]          Genre
            - [Item[]]          Genres
            - [Credit[]]        Creators
            - [Credit[]]        Cast
            - [Credit[]]        Crew
            - [String]          Year
            - [String]          FirstAirDate
            - [String]          LastAirDate
            - [int32]           TotalSeasons
            - [int32]           TotalEpisodes
            - [Boolean]         InProduction
            - [String]          Status
            - [String[]]        Country
            - [Entity[]]        Studios
            - [Entity[]]        Networks
            - [String]          HomePage
            - [String]          PosterPath
            - [String]          BackdropPath
            - [String]          PosterURL
            - [String]          BackdropURL
            - [TVSeason[]]      Seasons = @()
            - [TVEpisode[]]     Episodes = @()
            - [TVEpisode]       LastEpisode
            - [TVEpisode]       NextEpisode
            - [Item[]]          ExternalIDs
            - [Image[]]         Images

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -t, -ShowID. The TMDB TV Series/Show ID. Example: 615

    .PARAMETER IncludeCastAndCrewCredits
        OPTIONAL. Switch. Alias: -ccc. The TMDB Series/Show details do not include the cast or crew credits, which
        is a separate TMDB query. Use this switch to include the cast and crew credits in the results.

    .PARAMETER IncludeImages
        OPTIONAL. Switch. Alias: -img. TMDB includes a single poster and backdrop image representing the TV 
        Series/Show in the details. However, series may have multiple images available to select from. To include 
        links to all of the images matching the language specified in the "Language" parameter, include this 
        parameter.

    .PARAMETER IncludeExternalIDs
        OPTIONAL. Switch. Alias: -xid. TMDB includes the IDs used by other media databases (IMDB, Freebase, TVDB, 
        TVRage and Wikidata) for many of the the entries in it's catalog. Use this switch to include the IDs 
        of those entries (if they exist) in the series data.

    .PARAMETER IncludeSeasonDetails
        OPTIONAL. Switch. Alias: -isd. The TMDB Series/Show details include summary information for each season 
        which includes the season number, first air date, total number of episodes and poster. To get the full
        details of the season, including the episode listing, include this switch.

    .PARAMETER IncludeSeasonCastCredits
        OPTIONAL. Switch. Alias: -ccs. The TMDB Season details do not include the credits for cast or crew 
        members, which is a separate TMDB query. Use this switch to include the cast and crew credits 
        in the season details.

    .PARAMETER IncludeSeasonImages
        OPTIONAL. Switch. Alias: -imgs. TMDB includes a poster image representing the season in the season 
        details. However, seasons may have multiple images available to select from. To include links to all of 
        the images matching the language specified in the "Language" parameter, include this parameter.

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
        the images matching the language specified in the "Language" parameter, include this parameter.

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
        Get-TMdbTVSeries -SeriesID 615 -IncludeCredits

    .EXAMPLE
        Get-TMdbTVShow -ShowID 615 -IncludeCredits

    .EXAMPLE
        Get-TMdbTVSeries -t 615 -c

    #>
    [Alias('Get-TMdbTVShow')]
    [OutputType([TVShow])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('t','ShowID')] [String] $SeriesID,

        [Parameter()]          [Alias('ccc')]        [Switch] $IncludeCastAndCrewCredits,
        [Parameter()]          [Alias('img')]        [Switch] $IncludeImages,
        [Parameter()]          [Alias('xid')]        [Switch] $IncludeExternalIDs,

        [Parameter()]          [Alias('isd')]        [Switch] $IncludeSeasonDetails,
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

        if ( -not (Test-ApiTokenSet) ) { return @{ success = $false; message = $TOKEN_NOT_SET } }

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/tv/{0}'       -f $SeriesID ),
            $( '?language={0}' -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for TV Series/Show Details ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}' -f $SeriesID )
        Write-Msg -d -il 1 -m ( 'Token: {0}...'       -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'          -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $s = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($s) ) {
                
                $show = $( $s | Get-TVSeriesFromDetails )

                $show.Seasons | ForEach-Object { $_.ShowID = $SeriesID}

                $r = Get-TMdbContentRatings -t $SeriesID -c $($($Language.Split('-')[1]))
                if ( $r.success ) {
                    $show.Ratings = $r.value
                    $show.Rating  = $($r.value | Select-Object -First 1 -ExpandProperty 'rating')
                }

                if ( $IncludeCastAndCrewCredits ) {
                    $c = Get-TMdbCredits -t $SeriesID -l $Language
                    if ( $c.success ) {
                        $show.Cast = $c.value.cast
                        $show.Crew = $c.value.crew
                    }
                }

                if ( $IncludeImages ) {
                    $i = Get-TMdbImages -t $SeriesID -l $($Language.Split('-')[0])
                    if ( $i.success ) {
                        $show.Images = $i.value
                    }
                }

                if ( $IncludeExternalIDs ) {
                    $x = Get-TMdbExternalIDs -t $SeriesID
                    if ( $x.success ) {
                        $show.ExternalIDs = $x.value
                    }
                }
                
                if ( $IncludeSeasonDetails ) {

                    [TVSeason[]] $seasons = @()

                    $show.Seasons | ForEach-Object {

                        $params = @{
                            SeriesID                            = $_.ShowID
                            SeasonNumber                        = $_.Number
                            IncludeSeasonCastCredits            = $IncludeSeasonCastCredits
                            IncludeSeasonImages                 = $IncludeSeasonImages
                            IncludeSeasonExternalIDs            = $IncludeSeasonExternalIDs
                            IncludeEpisodeCastCredits           = $IncludeEpisodeCastCredits
                            IncludeEpisodeImages                = $IncludeEpisodeImages
                            IncludeEpisodeExternalIDs           = $IncludeEpisodeExternalIDs
                            IncludeSeasonCastCreditsForEpisodes = $IncludeSeasonCastCreditsForEpisodes
                            Language                            = $Language
                        }

                        $r = Get-TMdbTVSeason @params

                        if ( $r.success ) {
                            $seasons += $r.value
                        }

                    }

                    $show.Seasons = $seasons

                }

                $result = @{ success = $r.success; value = $show }
                
            }
            else {
                $result = @{ success = $r.success; value = $null }
            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            $result = @{ success = $false; message = 'No results found for query.' }
        }
        else {
            $result = $r
        }

        Write-Msg -FunctionResult -Object $result -MaxRecursionDepth 10

        return $result
    }
}
