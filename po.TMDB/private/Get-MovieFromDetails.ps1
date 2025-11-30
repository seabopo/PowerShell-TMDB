Function Get-MovieFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains information about a single Movie.

    .OUTPUTS
        A single [Movie] object with the following properties:
            - [String]          Source
            - [String]          ID
            - [Bool]            Adult
            - [String]          Title
            - [String]          Tagline
            - [String]          OriginalTitle
            - [String]          OriginalLanguage
            - [String]          Description
            - [String]          Genre
            - [Item[]]          Genres
            - [String]          ReleaseDate
            - [String]          Year
            - [String]          Rating
            - [ContentRating[]] Ratings
            - [String]          Status
            - [Int]             Runtime
            - [Entity[]]        Studios
            - [Int]             Budget
            - [Int]             Revenue
            - [String]          HomePage
            - [String]          BackdropPath
            - [String]          PosterPath
            - [String]          BackdropURL
            - [String]          PosterURL
            - [Credit[]]        Cast
            - [Credit[]]        Crew
            - [Collection[]]    Collections
            - [Item[]]          ExternalIDs
   
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
            Tagline          = $MovieData.tagline
            OriginalTitle    = $MovieData.original_title
            OriginalLanguage = $MovieData.original_language
            Description      = $MovieData.overview

            ReleaseDate      = $MovieData.release_date
            Year             = $( if ( Test-IsNothing($MovieData.release_date) ) { '' } 
                                  else { ([datetime]($MovieData.release_date)).Year } )
            Status           = $MovieData.status
            Runtime          = $MovieData.runtime
            Budget           = $MovieData.budget
            Revenue          = $MovieData.revenue
            HomePage         = $MovieData.homepage
            BackdropPath     = $MovieData.backdrop_path
            PosterPath       = $MovieData.poster_path
            PosterURL        = @( if ( Test-IsNothing($MovieData.poster_path) ) { $null }
                                  else { $IMG_BASE_URI + $MovieData.poster_path } )
            BackdropURL      = @( if ( Test-IsNothing($MovieData.backdrop_path) ) { $null }
                                  else { $IMG_BASE_URI + $MovieData.backdrop_path } )
        }))

        if ( Test-IsSomething($MovieData.genre_ids) ) {
            $movie.Genres = $MovieData.genre_ids | ForEach-Object {
                                [Item]::New($_,$(Get-GenreNameFromID -Movie -ID $_))
                            }
        }

        if ( Test-IsSomething($MovieData.genres) ) {
            $movie.Genres = $MovieData.genres
        }
             
        if ( Test-IsSomething($MovieData.production_companies) ) { 
            $movie.Studios = $MovieData.production_companies | Get-EntityFromDetails
        }

        if ( Test-IsSomething($MovieData.imdb_id) ) { 
            $movie.ExternalIDs = [Item]::new(@{ name = 'imdb'; id = $MovieData.imdb_id })
        }
 
        if ( Test-IsSomething($MovieData.belongs_to_collection) ) { 
            $movie.Collections = $MovieData.belongs_to_collection | Get-CollectionFromDetails
        }
       
        Write-Msg -FunctionResult -o $movie

        return $movie
    }
}
