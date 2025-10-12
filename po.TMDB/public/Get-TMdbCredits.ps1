Function Get-TMdbCredits {
    <#
    .DESCRIPTION
        Gets the credits of a Movie, TV Show, TV Season or TV Episode.

    .OUTPUTS
        A collection of [Credit] objects with the following properties:
            - [String] Type             : The Credit type/category: Cast, Crew, Creator or Guest.
            - [String] Role             : Their Job (crew) or character (cast and guest stars)
            - [String] Name             : The person's name.
            - [String] OriginalName     : The person's alternate credit name.
            - [String] ID               : The TMDB entry ID of the person.
            - [String] CreditID         : The Credit ID for this role.
            - [Int]    CreditOrder      : The order in which the person's credit appears in the Movie or TV Show.
            - [String] ProfileImagePath : The persons profile image name.
            - [String] ProfileImageURL  : The fully-qualified URL to the person's profile image.

    .PARAMETER MovieID
        REQUIRED. String. Alias: -m. The Movie ID. Example: 18

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -t, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        OPTIONAL. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        OPTIONAL. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbCredits -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbCredits -SeriesID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbCredits -ShowID 615

    .EXAMPLE
        Get-TMdbCredits -MovieID 615

    .EXAMPLE
        Get-TMdbCredits -t 615 -s 1 -e 1

    .EXAMPLE
        Get-TMdbCredits -m 18

    #>
    [OutputType([Credit[]])]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = "M", Mandatory)] 
        [Alias('m')]          [String] $MovieID,

        [Parameter(ParameterSetName = "T", Mandatory)] 
        [Alias('t','ShowID')] [String] $SeriesID,

        [Parameter(ParameterSetName = "T")]
        [Alias('s')]          [System.Nullable[int]] $SeasonNumber,
        
        [Parameter(ParameterSetName = "T")]
        [Alias('e')]          [System.Nullable[int]] $EpisodeNumber,
        
        [Parameter()]
        [Alias('l')]          [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        if ( -not (Test-ApiTokenSet) ) { return @{ success = $false; message = $TOKEN_NOT_SET } }

        if ( Test-IsSomething($MovieID) ) {
            $label  = 'Movie'
            $itemID = $MovieID
            $query  = $('/movie/{0}' -f $MovieID)
        }
        else {
            $label   = 'Series/Show'
            $itemID  = $SeriesID
            $show    = $('/tv/{0}' -f $SeriesID)
            $season  = ( $null -eq $SeasonNumber  ) ? $null : $( '/season/{0}'  -f $SeasonNumber )
            $episode = ( $null -eq $EpisodeNumber ) ? $null : $( '/episode/{0}' -f $EpisodeNumber )
            $query   = @( $show, $season, $episode ) -Join ''
        }

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( $query ),
            $( '/credits' ),
            $( '?language={0}' -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for Credits ...' )
        Write-Msg -i -il 1 -m ( '{0} ID: {1}'             -f $label, $itemID )
        if ( $SeasonNumber ) {
            Write-Msg -i -il 1 -m ( 'Season Number: {0}'  -f $SeasonNumber )
        }
        if ( $EpisodeNumber ) {
            Write-Msg -i -il 1 -m ( 'Episode Number: {0}' -f $EpisodeNumber )
        }
        Write-Msg -d -il 1 -m ( 'Token: {0}...'           -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'              -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $c = ($r.value | ConvertFrom-Json)

            if ( Test-IsSomething($c) ) {

                [Hashtable] $credits = @{}

                if ( Test-IsSomething($c.cast) ) {
                    $credits.cast = $c.cast | Get-CreditFromDetails -t 'Cast'
                }

                if ( Test-IsSomething($c.guest_stars) ) {
                    $credits.guests = $c.guest_stars | Get-CreditFromDetails -t 'Guest'
                }

                if ( Test-IsSomething($c.crew) ) {
                    $credits.crew = $c.crew | Get-CreditFromDetails -t 'Crew'
                }

                $result = @{ success = $true; value = $credits }

            }
            else {
                $result = @{ success = $true; value = $null }
            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            $result = @{ success = $false; message = 'No results found for query.' }
        }
        else {
            $result = $r
        }

        Write-Msg -FunctionResult -Object $result

        return $result
    }
}
