Function Get-MovieContentRatingsFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains content rating information about a Movie.

    .OUTPUTS
        A single [ContentRating] object with the following properties:

   
    .PARAMETER ReleaseData
        REQUIRED. Hashtable. Alias: -d. Release data.

    .EXAMPLE
        Get-MovieContentRatingsFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-MovieContentRatingsFromDetails 

    #>
    [OutputType([ContentRating])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $ReleaseData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $country = $ReleaseData.iso_3166_1

        if ( $ReleaseData.release_dates.Count -eq 1 ) {
            $rating = $ReleaseData.release_dates[0].certification

        }
        elseif ( $ReleaseData.release_dates.Count -gt 1 ) {
            $ratings = $ReleaseData.release_dates | 
                       Select-Object -ExpandProperty 'certification' | 
                       Where-Object { Test-IsSomething($_) } |
                       Sort-Object -Unique -Descending
            if ( $ratings.count -eq 1 ) {
                $rating = $ratings
            }
            else {
                Write-Msg -d -il 1 -m $( 'Multiple Ratings Found: {0}' -f $($ratings -join ',') )
                $rating = $ratings | Group-Object | 
                                     Sort-Object -Property 'Name'  -Descending |
                                     Sort-Object -Property 'Count' -Descending | 
                                     Select-Object -First 1 -ExpandProperty 'name'
                Write-Msg -d -il 1 -m $( 'Selected Value: {0}' -f $rating )
                Write-Msg -d -il 1 -m $( 'Selected Value: {0}' -f $rating )
            }
        }

        $contentRating = $([ContentRating]::New(@{
            Country     = $country
            Rating      = $rating
        }))

        Write-Msg -FunctionResult -o $contentRating

        return $contentRating
    }
}
