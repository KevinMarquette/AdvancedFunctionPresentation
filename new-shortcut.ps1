function new-shortcut {
    <#
        .Synopsis
        Creates a new shortcut

        .Example
        $Path = "$env:SystemRoot\System32\notepad.exe"
        $Destination = "$env:USERPROFILE\Desktop\notepad.lnk"
        New-Shortcut -Path $Path -Destination $Destination

        .Example
        $shortcuts = Import-Csv -Path .\shortcuts.csv
        $shortcuts | New-Shortcut -Verbose


        .Notes
        
    #>
    [cmdletbinding()]
    param(
        # Source file
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        # location to save the shortcut
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Destination
    )

    begin {
        $WScriptShell = New-Object -ComObject WScript.Shell
    }

    process {
        try {
            Write-Verbose "Creating shortcut to [$path] at [$destination] "
            $Shortcut = $WScriptShell.CreateShortcut($Destination)
            $Shortcut.TargetPath = $Path
            $Shortcut.Save()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
