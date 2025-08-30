Function Get-TVSeriesFromSearchResults {
    <#
    .DESCRIPTION
        Creates an object which contains summary information about a single TV Series/Show from a set of search 
        results.
    
    .OUTPUTS
        A single [TVShow] object with the following POPULATED properties:
            - [String]          Source
            - [String]          ID
            - [String]          Name
            - [String]          OriginalName
            - [String]          Description
            - [String[]]        Country
            - [Item[]]          Genres
            - [String]          PosterPath
            - [String]          BackdropPath
            - [String]          Year
            - [String]          FirstAirDate

    .PARAMETER SeriesData
        REQUIRED. Hashtable. Alias: -d. Series data.

    .EXAMPLE
        Get-TVSeriesFromSearchResults  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-TVShowFromSearchResults 

    #>
    [Alias('Get-TVShowFromSearchResults')]
    [OutputType([TVShow])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $SeriesData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $show = $([TVShow]::New(@{
            Source       = 'TMDB'
            ID           = $SeriesData.ID
            Name         = $SeriesData.name
            OriginalName = $SeriesData.original_name
            Description  = $SeriesData.overview
            Country      = $SeriesData.origin_country
            PosterPath   = $SeriesData.poster_path
            BackdropPath = $SeriesData.backdrop_path
            FirstAirDate = $SeriesData.first_air_date
            Genres       = $SeriesData.genre_ids | ForEach-Object { 
                                                       [Item]::New($_,$(Get-GenreNameFromID -TV -ID $_)) 
                                                   }
            Year         = $( if (Test-IsNothing($SeriesData.first_air_date)) { '' } 
                              else { ([datetime]($SeriesData.first_air_date)).Year } )
        }))

        Write-Msg -FunctionResult -o $show

        return $show
    }
}
