Function Get-MovieFromSearchResults {
    <#
    .DESCRIPTION
        Creates an object which contains information about a single Movie from a set of search results.

    .OUTPUTS
        A single [Movie] object with the following POPULATED properties:
            - [String] $Source
            - [String] $ID
            - [Bool]   $Adult
            - [String] $Title
            - [String] $OriginalTitle
            - [String] $OriginalLanguage
            - [String] $Description
            - [String] $LongDescription
            - [Item[]] $Genres
            - [String] $ReleaseDate
            - [String] $Year
            - [String] $BackdropPath
            - [String] $PosterPath
            - [String] $BackdropURL
            - [String] $PosterURL
   
    .PARAMETER MovieData
        REQUIRED. Hashtable. Alias: -d. Movie data.

    .EXAMPLE
        Get-MovieFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-MovieFromDetails 

    #>
    [OutputType([Movie])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $MovieData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $movie = $([Movie]::New(@{
            Source           = 'TMDB'
            ID               = $MovieData.ID
            Adult            = $MovieData.adult
            Title            = $MovieData.title
            OriginalTitle    = $MovieData.original_title
            OriginalLanguage = $MovieData.original_language
            Description      = $MovieData.overview
            Genres           = $MovieData.genre_ids | ForEach-Object { 
                                                          [Item]::New($_,$(Get-GenreNameFromID -Movie -ID $_))
                                                      }
            ReleaseDate      = $MovieData.release_date
            Year             = $( if ( [String]::IsNullOrEmpty($MovieData.release_date) ) { '' } 
                                  else { ([datetime]($MovieData.release_date)).Year } )
            BackdropPath     = $MovieData.backdrop_path
            PosterPath       = $MovieData.poster_path
            PosterURL        = @( if ( [String]::IsNullOrEmpty($MovieData.poster_path) ) { $null }
                                  else { $IMG_BASE_URI + $MovieData.poster_path } )
            BackdropURL      = @( if ( [String]::IsNullOrEmpty($MovieData.backdrop_path) ) { $null }
                                  else { $IMG_BASE_URI + $MovieData.backdrop_path } )
        }))

        Write-Msg -FunctionResult -o $movie

        return $movie
    }
}
