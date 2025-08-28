Function Get-TVSeasonFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains information about a single TV Season, including the episodes.

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

    .PARAMETER SeasonData
        REQUIRED. Hashtable. Alias: -d. Season data.

    .EXAMPLE
        Get-TVSeasonFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-TVSeasonFromDetails 

    #>
    [OutputType([TVSeason])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $SeasonData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $season = $([TVSeason]::New(@{
            Source           = 'TMDB'
            ID               = $SeasonData.id
            Number           = $SeasonData.season_number
            Name             = $SeasonData.name
            Description      = $SeasonData.overview
            FirstAirDate     = $SeasonData.air_date
            TotalEpisodes    = $SeasonData.episode_count
            PosterPath       = $SeasonData.poster_path
            PosterURL        = @( if ( [String]::IsNullOrEmpty($SeasonData.poster_path) ) { $null }
                                  else { $IMG_BASE_URI + $SeasonData.poster_path } )
            Year             = $( if ([String]::IsNullOrEmpty($SeasonData.air_date)) { '' } 
                                  else { ([datetime]($SeasonData.air_date)).Year } )
            Episodes         = $( if ([String]::IsNullOrEmpty($SeasonData.episodes)) { $null } 
                                  else { $SeasonData.episodes | Get-TVEpisodeFromDetails } )
        }))

        Write-Msg -FunctionResult -o $season

        return $season
    }
}
