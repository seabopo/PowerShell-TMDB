Function Get-TVSeriesFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains information about a single TV Series/Show, including the seasons, 
        episodes and artwork.

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
   
    .PARAMETER SeriesData
        REQUIRED. Hashtable. Alias: -d. Series data.

    .EXAMPLE
        Get-TVSeriesFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-TVSeriesFromDetails 

    #>
    [OutputType([TVShow])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $SeriesData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $show = $([TVShow]::New(@{
            Source        = 'TMDB'
            ID            = $SeriesData.ID
            Name          = $SeriesData.name
            OriginalName  = $SeriesData.original_name
            Description   = $SeriesData.overview
            TotalSeasons  = $SeriesData.number_of_seasons
            TotalEpisodes = $SeriesData.number_of_episodes
            LastEpisode   = $( if ( [String]::IsNullOrEmpty($SeriesData.last_episode_to_air) ) { $null }
                               else { $SeriesData.last_episode_to_air | Get-TVEpisodeFromDetails } )
            NextEpisode   = $( if ( [String]::IsNullOrEmpty($SeriesData.next_episode_to_air) ) { $null }
                               else { $SeriesData.next_episode_to_air | Get-TVEpisodeFromDetails } )
            InProduction  = [Bool]$SeriesData.in_production
            Status        = $SeriesData.status
            Year          = $( if ( [String]::IsNullOrEmpty($SeriesData.first_air_date) ) { '' } 
                               else { ([datetime]($SeriesData.first_air_date)).Year } )
            FirstAirDate  = $SeriesData.first_air_date
            LastAirDate   = $SeriesData.last_air_date
            Networks      = $( $SeriesData.networks | Get-EntityFromDetails )
            Studios       = $( $SeriesData.production_companies | Get-EntityFromDetails )
            Country       = $SeriesData.origin_country
            Genres        = $SeriesData.genres
            Creators      = $( $SeriesData.created_by | Get-CreditFromDetails -t 'Creator' )
            HomePage      = $SeriesData.homepage
            PosterPath    = $SeriesData.poster_path
            BackdropPath  = $SeriesData.backdrop_path
            PosterURL     = @( if ( [String]::IsNullOrEmpty($SeriesData.poster_path) ) { $null }
                               else { $IMG_BASE_URI + $SeriesData.poster_path } )
            BackdropURL   = @( if ( [String]::IsNullOrEmpty($SeriesData.backdrop_path) ) { $null }
                               else { $IMG_BASE_URI + $SeriesData.backdrop_path } )
            Seasons       = $( if ( [String]::IsNullOrEmpty($SeriesData.seasons) ) { $null }
                               else { $SeriesData.seasons | Get-TVSeasonFromDetails } )
        }))

        Write-Msg -FunctionResult -o $show

        return $show
    }
}


