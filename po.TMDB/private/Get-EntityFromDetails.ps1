Function Get-EntityFromDetails {
    <#
    .DESCRIPTION
        Creates object which contains information about a production company, studio or network.

    .OUTPUTS
        A single [Entity] object with the following properties:
            - [String] Name     : 
            - [String] ID       : 
            - [String] Country  : 
            - [String] LogoPath : 
            - [String] LogoURL  : 

    .PARAMETER EntityData
        REQUIRED. Hashtable. Alias: -d. Data about a production company, studio or network.

    .EXAMPLE
        Get-EntityFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-EntityFromDetails

    #>
    [OutputType([Entity])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $EntityData
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $entity = $([Entity]::New(@{
            Name     = $EntityData.name
            ID       = $EntityData.id
            Country  = $EntityData.origin_country
            LogoPath = $EntityData.logo_path
            LogoURL  = @( if ( [String]::IsNullOrEmpty($EntityData.logo_path) ) { $null }
                          else { $IMG_BASE_URI + $EntityData.logo_path } )
        }))

        Write-Msg -FunctionResult -o $entity

        return $entity
    }
}
