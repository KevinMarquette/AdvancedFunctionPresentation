# Build an advanced function

# Original Script
$TargetFile = "$env:SystemRoot\System32\notepad.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\Notepad.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

# example 1
$Path = "$env:SystemRoot\System32\notepad.exe"
$Destination = "$env:USERPROFILE\Desktop\notepad.lnk"
New-Shortcut -Path $Path -Destination $Destination

# example 2
$shortcuts = Import-Csv -Path .\shortcuts.csv
$shortcuts | New-Shortcut -Verbose


cleanup

# build this function
code .\new-shortcut.ps1


# example if needed:
code .\new-shortcut.example.ps1
