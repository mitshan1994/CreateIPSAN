# CreateIPSAN
Powershell script to create IP SAN on Windows based on StarWind VSAN FREE.

## Motivation

StarWind offers a free unlimited version for us. The only disadvantage is that the GUI is not offered, and command line tools is the only choice. So, for someone who want to use it to create IP SAN but do not want to pay for it for some reason, I create a script to automate the process.

Along the way, StarWind official powershell script examples are very informative, since I didn't find the official command line manual (maybe they don't offer this on purpose because it's free). I didn't really read the "free" policy carefully so you should read it if you want to use it to create IP SANs for commercial reason.

## Usage

Steps:

1. Install StarWind VSAN FREE. (requires vc++ 2015 redistributable x64, .NET 4.0 or higher version)
2. Run PowerShell as administrator, and enter "set-executionpolicy remotesigned" to enable script execution. After confirmation, close the powershell window.
3. Download two files in this repo (double_click_to_create_ipsan.bat and create_ipsan.ps1) to the disk where you want to use as an IP SAN.
4. Double click the file "double_click_to_create_ipsan.bat" to create the IP SAN.

After these, you can now find your disk is almost full and use iSCSI to connect to this virtual IP SAN (ensure IP SAN default TCP port 3260 is enable in FireWall inbound rules).

## Tested platform

Windows Server 2008 R2, NTFS disk.

## Note

Since I only test it on Windows Server 2008 R2, the script creates more than one image files on the disk if disk size is greater than 16 TB, corresponding to the maximum file size of OS.