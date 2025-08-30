Function Get-TVEpisodeFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains information about a single TV Series/Show Episode.

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

    .PARAMETER EpisodeData
        REQUIRED. Hashtable. Alias: -d. Episode data.

    .EXAMPLE
        Get-TVEpisodeFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-TVEpisodeFromDetails

    #>
    [OutputType([TVEpisode])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $EpisodeData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $episode = $([TVEpisode]::New(@{
            Source         = 'TMDB'
            ShowID         = $EpisodeData.show_id
            ID             = $EpisodeData.id
            Season         = $EpisodeData.season_number
            Number         = $EpisodeData.episode_number
            Type           = $EpisodeData.episode_type
            Title          = $EpisodeData.name
            Description    = $EpisodeData.overview
            ProductionCode = $EpisodeData.production_code
            AirDate        = $EpisodeData.air_date
            Runtime        = $EpisodeData.runtime
            StillPath      = $EpisodeData.still_path
            StillURL       = @( if ( Test-IsNothing($EpisodeData.still_path) ) { $null }
                                else { $IMG_BASE_URI + $EpisodeData.still_path } )
            Crew           = $( if ( Test-IsNothing($EpisodeData.crew) ) { $null }
                                else { $EpisodeData.crew | Get-CreditFromDetails -t 'Crew' })
            Guests         = $( if ( Test-IsNothing($EpisodeData.guest_stars) ) { $null }
                                else { $EpisodeData.guest_stars | Get-CreditFromDetails -t 'Guest' })
        }))

        Write-Msg -FunctionResult -o $episode

        return $episode
    }
}
