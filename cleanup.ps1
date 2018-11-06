function cleanup {
    $fileList = @(
        "$env:USERPROFILE\Desktop\Notepad.lnk"
        "$env:USERPROFILE\Desktop\wscript.lnk"
        "$env:USERPROFILE\Desktop\write.lnk"
        "$env:USERPROFILE\Desktop\Taskmgr.lnk"
    )
    foreach ($file in $fileList) {
        if (Test-Path $file) {
            Write-Verbose "removing [$file]" -Verbose:$true
            Remove-Item -Path $file
        }
    }
}
