Function Get-TVContentRatingFromDetails {
    <#
    .DESCRIPTION
        Creates an object containing the Content Rating details of a single country.

    .OUTPUTS
        A single [ContentRating] object with the following properties:
           - [String]   $Country     : "US"
           - [String]   $Rating      : "TV-14"
           - [String[]] $Descriptors : ["L","V"]

    .PARAMETER RatingData
        REQUIRED. Hashtable. Alias: -d. Data about a single country's content rating for a series.

    .EXAMPLE
        Get-TVContentRatingFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-TVContentRatingFromDetails

    #>
    [OutputType([ContentRating])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $RatingData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $rating = $([ContentRating]::New(@{
            Country     = $RatingData.iso_3166_1
            Rating      = $RatingData.rating
            Descriptors = $RatingData.descriptors
        }))

        Write-Msg -FunctionResult -o $rating

        return $rating
    }
}
