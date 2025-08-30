Function Get-CreditFromDetails {
    <#
    .DESCRIPTION
        Creates an object which contains information about a single person and their role in a Movie or 
        TV Series/Show.

    .OUTPUTS
        A single [Credit] object with the following properties:
            - [String] Type             : The Credit type/category: Cast, Crew, Creator or Guest.
            - [String] Role             : Their Job (crew) or character (cast and guest stars).
            - [String] Name             : The person's name.
            - [String] OriginalName     : The person's alternate credit name.
            - [String] ID               : The TMDB entry ID of the person.
            - [String] CreditID         : The Credit ID for this role.
            - [Int]    CreditOrder      : The order in which the person's credit appears in the Movie or TV Show.
            - [String] ProfileImagePath : The persons profile image name.
            - [String] ProfileImageURL  : The fully-qualified URL to the person's profile image.

    .PARAMETER CreditData
        REQUIRED. Hashtable. Alias: -d. Data about the person and their role.
        
    .PARAMETER CreditType
        REQUIRED. String. Alias: -t. The type of credit. One of: Creator, Cast, Crew, Guest.

    .EXAMPLE
        Get-CreditFromDetails  -d @{ ...}
    
    .EXAMPLE
        @{ ...} | Get-CreditFromDetails

    #>
    [OutputType([Credit])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] 
        [Alias('d')] [PSCustomObject] $CreditData,

        [Parameter(Mandatory)]
        [ValidateSet('Creator','Cast','Crew','Guest')]
        [Alias('t')] [String] $CreditType
    )

    process {
        
        Write-Msg -FunctionCall -IncludeParameters
        
        $credit = $([Credit]::New(@{
            Type             = $CreditType
            Role             = $CreditData.character ?? $CreditData.Job ?? $CreditType
            Name             = $CreditData.name
            OriginalName     = $CreditData.original_name
            ID               = $CreditData.id
            CreditID         = $CreditData.credit_id
            CreditOrder      = $CreditData.order
            ProfileImagePath = $CreditData.profile_path
            ProfileImageURL  = @( if ( Test-IsNothing($CreditData.profile_path) ) { $null }
                                  else { $IMG_BASE_URI + $CreditData.profile_path } )
        }))

        Write-Msg -FunctionResult -o $credit

        return $credit
    }
}
