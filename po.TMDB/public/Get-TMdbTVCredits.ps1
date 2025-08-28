Function Get-TMdbTVCredits {
    <#
    .DESCRIPTION
        Gets the credits of a TV Show, TV Season or TV Episode.

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

    .PARAMETER SeriesID
        REQUIRED. String. Alias: -i, -ShowID. The TV Series/Show ID. Example: 615

    .PARAMETER SeasonNumber
        OPTIONAL. Int. Alias: -s. The Season Number of the Series/Show. Example: 1

    .PARAMETER EpisodeNumber
        OPTIONAL. Int. Alias: -e. The Episode Number of the Series/Show. Example: 1

    .PARAMETER Language
        OPTIONAL. String. Alias: -l. The desired target language of the query. The value defaults to the user's 
        operating system settings. Example: en-US

    .EXAMPLE
        Get-TMdbTVCredits -SeriesID 615 -SeasonNumber 1 -EpisodeNumber 1

    .EXAMPLE
        Get-TMdbTVCredits -SeriesID 615 -SeasonNumber 1

    .EXAMPLE
        Get-TMdbTVCredits -ShowID 615

    .EXAMPLE
        Get-TMdbTVCredits -i 615 -s 1 -e 1

    #>
    [OutputType([Credit[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i','ShowID')] [String] $SeriesID,
        [Parameter()]          [Alias('s')]          [System.Nullable[int]] $SeasonNumber,
        [Parameter()]          [Alias('e')]          [System.Nullable[int]] $EpisodeNumber,
        [Parameter()]          [Alias('l')]          [String] $Language = $((Get-Culture).Name.ToString())
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters

        $season  = ( $null -eq $SeasonNumber  ) ? $null : $( '/season/{0}'  -f $SeasonNumber )
        $episode = ( $null -eq $EpisodeNumber ) ? $null : $( '/episode/{0}' -f $EpisodeNumber )

        $SearchURL = @(
            $( $API_BASE_URI ),
            $( '/tv/{0}' -f $SeriesID ),
            $( $season ),
            $( $episode ),
            $( '/credits' ),
            $( '?language={0}' -f $Language )
        ) -Join ''

        Write-Msg -p -ps -m ( 'Querying TMDB for TV Credits ...' )
        Write-Msg -i -il 1 -m ( 'Series/Show ID: {0}'  -f $SeriesID )
        if ( $SeasonNumber ) {
            Write-Msg -i -il 1 -m ( 'Season Number: {0}'   -f $SeasonNumber )
        }
        if ( $EpisodeNumber ) {
            Write-Msg -i -il 1 -m ( 'Episode Number: {0}'  -f $EpisodeNumber )
        }
        Write-Msg -d -il 1 -m ( 'Token: {0}...'        -f $($env:TMDB_API_TOKEN).Substring(0,8) )
        Write-Msg -d -il 1 -m ( 'Query: {0}'           -f $SearchURL )
        
        $r = Invoke-HttpRequest -u $SearchURL -t $env:TMDB_API_TOKEN -j -d

        if ( $r.success -and $r.statusCode -eq 200 ) {
            
            $c = ($r.value | ConvertFrom-Json)

            if ( -not ([String]::IsNullOrEmpty($c)) ) {

                [Hashtable] $credits = @{}

                if ( -not ([String]::IsNullOrEmpty($c.cast)) ) {
                    $credits.cast = $c.cast | Get-CreditFromDetails -t 'Cast'
                }

                if ( -not ([String]::IsNullOrEmpty($c.guest_stars)) ) {
                    $credits.guests = $c.guest_stars | Get-CreditFromDetails -t 'Guest'
                }

                if ( -not ([String]::IsNullOrEmpty($c.crew)) ) {
                    $credits.crew = $c.crew | Get-CreditFromDetails -t 'Crew'
                }

            }

        }
        elseif ( -not $r.success -and $r.statusCode -eq 404 ) {
            Write-Msg -e -ps -ds -m $('No results found for query.')
        }
        else {
            Write-Msg -e -ps -ds -m $($r.message)
        }

        Write-Msg -FunctionResult -Object $credits

        return @{ success = $r.success; value = $credits }
    }
}
