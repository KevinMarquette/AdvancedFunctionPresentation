break;

# pipeline output

function Test-Output
{
    foreach ( $number in 10..15 )
    {
        $number
    }
}

$data = Test-Output
$data.count
$data


# 2nd example (extra output)
function Test-Pipeline
{
    'Everything on the pipeline is in the output'
    Get-WmiObject Win32_Bios | Select Manufacturer
    'Even these text strings'
}

Test-Pipeline

$data = Test-Pipeline
$data[0]
$data[1]
$data[2]


# add Verbose output
function Test-Verbose
{
    Write-Verbose "Querying for Manufacturer"
    Get-WmiObject Win32_Bios | Select Manufacturer
}

Test-Verbose

$data = Test-Verbose
$data[0]

Test-Verbose -Verbose

$VerbosePreference = 'Continue'
Test-Verbose
$VerbosePreference = 'SilentlyContinue'


# Advanced function with CmdletBinding
function Test-Verbose
{
    [cmdletbinding()]
    param()

    Write-Verbose "Querying for Manufacturer"
    Get-WmiObject Win32_Bios | Select Manufacturer
}

Test-Verbose

Test-Verbose -Verbose

$data = Test-Verbose -Verbose
$data[0].Manufacturer

# Common parameter support
Get-Command Test-Verbose -Syntax

Get-Help about_CommonParameters
start https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_CommonParameters?view=powershell-6


# messaging

function Test-Message
{
    [CmdletBinding()]
    param(
        [Switch]$SkipThrow
    )
    "First value in pipeline"
    Write-Output "Second value in Pipeline"
    Write-Host "Direct to host message" -ForegroundColor Green
    Write-Information "Optional to host message"
    Write-Verbose "Optional verbose message"
    Write-Debug "*Optional debug message"
    Write-Warning "Warning Message"
    Write-Error "Error Message"

    if ( -Not $SkipThrow )
    {
        Throw "Exception"
    }
}

Test-Message -Verbose -InformationAction Continue

$data = Test-Message -SkipThrow
$data

# Capturing Write-Host and Write-Information
$data = Test-Message -SkipThrow -InformationVariable InfoStream
$InfoStream

# Controlling message streams
$testMessageSplat = @{
    WarningAction = 'Ignore'
    InformationVariable = 'InfoStream'
    ErrorAction = 'SilentlyContinue'
}
$data = Test-Message @testMessageSplat
$data


# Write-Host Output Stream Redirect

$data = Test-Message -SkipThrow *>&1
$data[5]

# Debug

function Test-Debug
{
    [CmdletBinding()]
    param()
    Write-Debug "First Debug Message"
    "Do something"
    Write-Debug "Second Debug Message"
    "Do something else"
    Write-Debug "Third Debug Message"
}

Test-Debug

Test-Debug -Debug

$DebugPreference = 'Continue'
Test-Debug
$DebugPreference = 'SilentlyContinue'


# Returning values

function Test-Output
{
    foreach( $number in 10..15 )
    {
        $number
    }
}
# return statement

function Test-Return
{
    [cmdletbinding()]
    param()

    Write-Verbose 'Start counting'
    foreach( $number in 1..15 )
    {
        Write-Verbose "  $number"
        if ( $number -gt 4 )
        {
            return $number
        }
    }
    Write-Verbose "End of function"
}

Test-Return

Test-Return -Verbose

# Return to exit
function Test-Return2
{
    [cmdletbinding()]
    param()

    Write-Verbose 'Start counting'
    foreach( $number in 1..15 )
    {
        Write-Verbose "  $number"
        $number

        if ( $number -gt 4 )
        {
            return
        }
    }
    Write-Verbose "End of function"
}

Test-Return2

#end of file

