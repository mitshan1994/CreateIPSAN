Import-Module StarWindX

function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

try {

    #Enable-SWXLog

    $server = New-SWServer -host 127.0.0.1 -port 3261 -user root -password starwind

    $script_path = Get-ScriptDirectory
    $drive_letter = $script_path.Substring(0, 1)

    $free_space = (Get-WMIObject Win32_Logicaldisk -filter "deviceid='${drive_letter}:'").FreeSpace

    $remain_gb = [System.Math]::Floor($free_space / (1024 * 1024 * 1024))

    # spare 1 GB for unknown reason
    $remain_gb = $remain_gb - 1

    Write-Host "total size we will use : ${remain_gb} GB"

    # create one or more image files
    # try to change "max_image_size" to the maximum size of file enabled by OS
    # since 16 TB is the maximum size of file on Windows Server 2008 R2, we use it.
    $max_image_size = 16 * 1024
    $i = 0
    While ($remain_gb -gt 0) {
        $image_size = $remain_gb
        If ($remain_gb -gt $max_image_size) {
            $image_size = $max_image_size
        }
        Write-Host "creating image file: ${image_size} GB"
        New-ImageFile -server $server -path "My Computer\${drive_letter}" `
                      -fileName "ipsan_img${i}" -size ($image_size * 1024)

        $remain_gb = $remain_gb - $image_size
        $i = $i + 1
    }

    Write-Host "Total ${i} image files created"

    $device_names = @()
    for ($j = 0; $j -lt $i; $j++) {
        $device = Add-ImageDevice -server $server -path "My Computer\${drive_letter}" `
                                  -fileName "ipsan_img${j}" -sectorSize 4096
        $device_names += ,${device}.Name
    }

    $device_names
    
    if ($i -gt 0) {
        $target = New-Target -server $server -alias "ipsan_alias" -devices $device_names
        $target
    }
}
catch {
    Write-Host $_ -foreground red
}
finally {
    $server.Disconnect()
}

Write-Host "IP SAN creation finished."
