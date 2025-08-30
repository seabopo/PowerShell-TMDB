Function Get-CollectionFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains information about a media collection.

    .OUTPUTS
        A single [Collection] object with the following properties:
            - [String] ID
            - [String] Name
            - [String] BackdropPath
            - [String] PosterPath
            - [String] BackdropURL
            - [String] PosterURL

    .PARAMETER CollectionData
        REQUIRED. Hashtable. Alias: -d. Data about the collection.

    .EXAMPLE
        Get-CollectionFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-CollectionFromDetails

    #>
    [OutputType([Collection])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $CollectionData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $collection = $([Collection]::New(@{
            ID           = $CollectionData.id
            Name         = $CollectionData.name
            BackdropPath = $CollectionData.profile_path
            BackdropURL  = @( if ( Test-IsNothing($CollectionData.profile_path) ) { $null }
                              else { $IMG_BASE_URI + $CollectionData.profile_path } )
            PosterPath   = $CollectionData.profile_path
            PosterURL    = @( if ( Test-IsNothing($CollectionData.profile_path) ) { $null }
                              else { $IMG_BASE_URI + $CollectionData.profile_path } )
        }))

        Write-Msg -FunctionResult -o $collection

        return $collection
    }
}
