Function Get-ImageFromDetails {
    <#
    .DESCRIPTION
        Creates an object containing the image properties of a single image.

    .OUTPUTS
        A single [Image] object with the following properties:
           - [String]  Type        : "poster" | "background" | "still" | "image"
           - [Decimal] AspectRatio : 0.667,
           - [Int]     Height      : 3000
           - [Int]     Width       : 2000
           - [String]  Language    : "en"
           - [String]  Path        : "/7bRHBrmSn5QLY1UJ32v4jeSoKzP.jpg"
           - [String]  URL         : "https://media.themoviedb.org/t/p/original/7bRHBrmSn5QLY1UJ32v4jeSoKzP.jpg"

    .PARAMETER ImageData
        REQUIRED. Hashtable. Alias: -d. Data about a single image related to a TV Series, Season or Show.

    .EXAMPLE
        Get-ImageFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-ImageFromDetails

    #>
    [OutputType([Image])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [Alias('d')] [PSCustomObject] $ImageData,

        [Parameter(Mandatory)]
        [ValidateSet('stills','posters','logos','backdrops')]
        [Alias('t')] [String] $ImageType
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $image = $([Image]::New(@{
            Type        = $ImageType.TrimEnd('s')
            AspectRatio = $ImageData.aspect_ratio
            Height      = $ImageData.height
            Width       = $ImageData.width
            Language    = $ImageData.iso_639_1
            Path        = $ImageData.file_path
            URL         = @( if ( [String]::IsNullOrEmpty($ImageData.file_path) ) { $null }
                             else { $IMG_BASE_URI + $ImageData.file_path } )
        }))

        Write-Msg -FunctionResult -o $image

        return $image
    }
}
