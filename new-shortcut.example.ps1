function New-Shortcut
{
    <#
    .Description
    Crates a new Shortcut

    .Example
    $Path = "$env:SystemRoot\System32\notepad.exe"
    $Destination = "$env:USERPROFILE\Desktop\notepad.lnk"
    New-Shortcut -Path $Path -Destination $Destination

    #>
    [Alias('Create-Shortcut','LNK')]
    [cmdletbinding()]
    param(
        [Alias('FullName','Source','FilePath')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Destination
    )

    begin
    {
        $WScriptShell = New-Object -ComObject WScript.Shell
    }

    process
    {
        $Shortcut = $WScriptShell.CreateShortcut($Destination)
        $Shortcut.TargetPath = $Path

        Write-Verbose "Saving [$Destination]" -Verbose:$true
        $Shortcut.Save()
    }
}
