break;
# Intro to functions
Get-Date

Get-Help -Name Get-Date

Get-Date -Year 2018 -Month 11 -Day 7

Get-Command

# basic function
function Write-GreenDate
{
    $date = Get-Date
    Write-Host $date -ForegroundColor Green
}

Write-GreenDate


# about names

Get-Verb | Out-GridView


# parameters
function Write-Green
{
    param( $Message )
    Write-Host $Message -ForegroundColor Green
}

Write-Green -Message 'Hello, SoCal PowerShell'
Write-Green -Message 'This is my message!'


# nested functions
function Write-Duck
{
    Write-Green -Message '  >o)'
    Write-Green -Message '  (_>'
}

Write-Duck


# Simple Scripts

$WScriptShell = New-Object -ComObject WScript.Shell
$notepad = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\Notepad.lnk")
$notepad.TargetPath = "$env:SystemRoot\System32\notepad.exe"
$notepad.Save()


cleanup
# Not so simple script

$WScriptShell = New-Object -ComObject WScript.Shell

$notepad = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\Notepad.lnk")
$notepad.TargetPath = "$env:SystemRoot\System32\notepad.exe"
$notepad.Save()

$wscript = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\wscript.lnk")
$wscript.TargetPath = "$env:SystemRoot\System32\wscript.exe"
$wscript.Save()

$write = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\write.lnk")
$write.TargetPath = "$env:SystemRoot\System32\write.exe"
$write.Save()

$Taskmgr = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\Taskmgr.lnk")
$Taskmgr.TargetPath = "$env:SystemRoot\System32\Taskmgr.exe"
$Taskmgr.Save()


cleanup
# Creating a function
# make it generic, use more variables

$TargetFile = "$env:SystemRoot\System32\notepad.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\Notepad.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()


cleanup
# New function

function New-Shortcut
{
    param( $TargetFile, $ShortcutFile )

    if (Test-Path $TargetFile)
    {
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.TargetPath = $TargetFile
    
        Write-Verbose "Saving [$ShortcutFile]" -Verbose:$true
        $Shortcut.Save()
    }
}


$TargetFile = "$env:SystemRoot\System32\notepad.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\Notepad.lnk"
New-Shortcut $TargetFile $ShortcutFile


cleanup

$TargetFile = "$env:SystemRoot\System32\notepad.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\notepad.lnk"
New-Shortcut $TargetFile $ShortcutFile

$TargetFile = "$env:SystemRoot\System32\wscript.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\wscript.lnk"
New-Shortcut $TargetFile $ShortcutFile

$TargetFile = "$env:SystemRoot\System32\write.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\write.lnk"
New-Shortcut $TargetFile $ShortcutFile

$TargetFile = "$env:SystemRoot\System32\Taskmgr.exe"
$ShortcutFile = "$env:USERPROFILE\Desktop\Taskmgr.lnk"
New-Shortcut $TargetFile $ShortcutFile


cleanup
# Names are self documenting

$shortcuts = Import-Csv -Path .\shortcuts.csv
$shortcuts | ForEach-Object {
    New-Shortcut $_.Path $_.Destination
}


cleanup


# end of file

