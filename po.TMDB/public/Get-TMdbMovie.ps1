Function Get-TMdbMovie {
    <#
    .DESCRIPTION
        Gets the details of a single movie.

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
            - [String]          LongDescription
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
            - [Image[]]         Images
            - [Item[]]          ExternalIDs

    .PARAMETER MovieID
        REQUIRED. String. Alias: -m. The Movie ID. Example: 18

    .PARAMETER IncludeImages
        OPTIONAL. Switch. Alias: -img. TMDB includes a single poster and backdrop image representing the Movie 
        in the details. However, a movie may have multiple images available to select from. To include 
        links to all of the images matching the language specified in the "Language" parameter, include this 
        parameter.

    .PARAMETER IncludeExternalIDs
        OPTIONAL. Switch. Alias: -xid. TMDB includes the IDs used by other media databases (IMDB, Freebase, TVDB, 
        TVRage and Wikidata) for many of the the entries in it's catalog. Use this switch to include the IDs 
        of those entries (if they exist) in the series data.

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbMovie -MovieID 18

    .EXAMPLE
        Get-TMdbMovie -MovieID 18 -IncludeImages

    .EXAMPLE
        Get-TMdbMovie -m 18 -img

    #>
    [OutputType([Movie])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('m')]   [String] $MovieID,
        [Parameter()]          [Alias('img')] [Switch] $IncludeImages,
        [Parameter()]          [Alias('xid')] [Switch] $IncludeExternalIDs,
        [Parameter()]          [Alias('l')]   [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        $country = $($Language.Split('-')[1])

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/movie/{0}'    -f $MovieID ),
            $( '?language={0}' -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for Movie Details ...' )
        Write-Msg -i -il 1 -m ( 'Movie ID: {0}' -f $MovieID )
        Write-Msg -d -il 1 -m ( 'Token: {0}...' -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'    -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $m = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($m) ) {
                
                $movie = $( $m | Get-MovieFromDetails )

                $r = $( Get-TMdbContentRatings -MovieID $MovieID -Country $country )
                if ( $r.success ) {
                    $movie.ratings = $r.value
                    $movie.rating  = $r.value | Select-Object -First 1 -ExpandProperty 'rating'
                }
                
                $c = Get-TMdbCredits -m $MovieID  -l $Language
                if ( $c.success ) {
                    $movie.Cast = $c.value.cast
                    $movie.Crew = $c.value.crew
                }
                
                if ( $IncludeImages ) {
                    $i = Get-TMdbImages -m $MovieID -l $($Language.Split('-')[0])
                    if ( $i.success ) {
                        $movie.Images = $i.value
                    }
                }

                if ( $IncludeExternalIDs ) {
                    $x = Get-TMdbExternalIDs -m $MovieID
                    if ( $x.success ) {
                        $movie.ExternalIDs = $x.value
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

        Write-Msg -FunctionResult -Object $movie -MaxRecursionDepth 10

        return @{ success = $r.success; value = $movie }
    }
}
