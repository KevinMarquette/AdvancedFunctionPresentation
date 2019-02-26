break;

# parameters

function Test-Parameters
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String] $First,

        [String]
        $Last
    )

    "$First $Last"
}

Test-Parameters 'Kevin' 'Marquette'
Test-Parameters -First 'Kevin' -Last 'Marquette'
Test-Parameters -Last 'Marquette' -First 'Kevin'

Test-Parameters
Test-Parameters -Last Marquette


# Validate parameters
function Test-Number
{
    [CmdletBinding()]
    param(
        [ValidateRange(100,200)]
        $Number
    )

    "Good number: $number"
}

Test-Number 1
Test-Number 133
Test-Number 999

Test-Number


#Validate Set
function Test-Set
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet('Green','Red','Blue')]
        $Color
    )

    "Your color: $color"
}

Test-Set -Color Red
Test-Set -Color Yellow

# Show more validate sets
function Test-AllVaidateAttributes
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true
        )]
        [ValidateCount(1)]
        [ValidateLength(0,10)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('\w*')]
        [ValidateSet('Green','Red','Blue')]
        [ValidateScript({$_ -eq $true})]
        $InputObject
    )
}


# Parameter sets

function Test-ParameterSet
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName='Name'
        )]
        $ComputerName,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName='Other'
        )]
        $IPAddress,

        $Description = 'none provided'
    )
    "ParameterSetName [{0}]" -f $PSCmdlet.ParameterSetName
    "  ComputerName [$ComputerName]"
    "  IPAddress    [$IPAddress]"
    "  Description  [$Description]"
}

Test-ParameterSet -ComputerName localhost -Description 'my computername'
Test-ParameterSet -IpAddress 127.0.0.1 -Description 'my IP'
Test-ParameterSet -IpAddress 127.0.0.1 -ComputerName localhost -Description 'my IP'

Test-ParameterSet DefaultParameterSet

# -WhatIf

function Test-WhatIf
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    Write-Verbose "Start function"
    if ( $PSCmdlet.ShouldProcess("Target Item") )
    {
        Write-Verbose "Starting action"
        Write-Host "Do-Something to Target Item" -ForegroundColor Red
    }
    Write-Verbose "End function"
}

Test-WhatIf

Test-WhatIf -WhatIf

Test-WhatIf -Verbose

Test-WhatIf -Confirm

# Confirm
function Test-ConfirmImpact
{
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param()

    if ( $PSCmdlet.ShouldProcess("Target Item") )
    {
        Write-Host "Do-Something to Target Item" -ForegroundColor Red
    }
}

Test-ConfirmImpact

# adjustable confirm impact level
$ConfirmPreference


# Use of ShouldContinue and Force
function Test-Confirm
{
    [CmdletBinding(
        SupportsShouldProcess
    )]
    param(
        [Switch]
        $Force
    )

    $target = "Target Item"
    if ( $Force -or $PSCmdlet.ShouldContinue($target,'Do you want to continue?') )
    {
        if ( $PSCmdlet.ShouldProcess($target) )
        {
            Write-Host "Do-Something to $target" -ForegroundColor Red
        }
    }
}

Test-Confirm

Test-Confirm -Force

# Can still use whatif
Test-Confirm -WhatIf
Test-Confirm -Force -WhatIf


# Pipeline

function Test-Pipeline
{
    [CmdletBinding()]
    param(
        [Parameter(
            ValueFromPipeline
        )]
        $InputObject
    )
    process
    {
        "InputObject [$InputObject]"
    }
}

"test" | Test-Pipeline

$data = 'Green','Red','Blue'
$data | Test-Pipeline

# Begin Process End

function Test-BPE
{
    [CmdletBinding()]
    param(
        [Parameter(
            ValueFromPipeline
        )]
        $InputObject
    )
    begin
    {
        Write-Verbose 'BPE Begin Block'
    }
    process
    {
        Write-Verbose 'BPE Process Block'
        "InputObject [$InputObject]"
    }
    end
    {
        Write-Verbose 'BPE End Block'
    }
}

Test-BPE -Verbose
$data = 'Green','Red','Blue'
$data | Test-BPE -Verbose


# InputObject

function Test-InputObject
{
    [CmdletBinding()]
    param(
        [Parameter(
            ValueFromPipeline,
            Position = 0
        )]
        [string[]]
        $InputObject
    )
    process
    {
        Write-Verbose 'Start Process Block'
        foreach ( $node in $InputObject )
        {
            "InputObject [$node]"
        }
    }
}

$data = 'Green','Red','Blue'
$data | Test-InputObject -Verbose
Test-InputObject -InputObject $data -Verbose


# Pipeline by Property Name

function Test-PipelineByName
{
    [CmdletBinding()]
    param(
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]
        $Age
    )
    process
    {
        "[$Name] is [$Age] years old"
    }
}

$data = [pscustomobject]@{
    Name = 'Alex'
    Age = '11'
    FavoriteColor = 'Blue'
}

$data | Test-PipelineByName

# Correcting property mapping

$data = [pscustomobject]@{
    FirstName = 'Alex'
    Age = '11'
}

$data | Test-PipelineByName 

$data | Test-PipelineByName -Name {$_.FirstName}

# using property alias to map values
function Test-PipelineByAlias
{
    [CmdletBinding()]
    param(
        [Alias('FirstName','FN')]
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]
        $Age
    )
    process
    {
        "[$Name] is [$Age] years old"
    }
}

$data = [pscustomobject]@{
    FirstName = 'Alex'
    Age = '11'
}

$data | Test-PipelineByAlias

# comment based help

function Test-Help
{
    <#
    .SYNOPSIS
    Shows the comment based help in action

    .DESCRIPTION
    This is an example of a documented function.

    .EXAMPLE
    Test-Help
    <no output>

    .EXAMPLE
    Get-Help Test-Help

    Shows the help for this function

    .PARAMETER FirstName
     The first name of our customer

    .NOTES
    This help can to before the function, but I find it better inside.
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-6
    
    #>
    [CmdletBinding()]
    param(
        
        [string]
        $FirstName,

        # The last name of the customer
        [string]
        $LastName
    )
}

Get-Help Test-Help
Get-Help Test-Help -Examples
Get-Help Test-Help -Parameter FirstName

# end of file

