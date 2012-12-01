<#
    @author ComFreek
    @license See LICENSE file.
#>

$scriptDir = (Split-Path $script:MyInvocation.MyCommand.Path);
. "$scriptDir\getRelativePath.ps1";

$icoFiles = Get-ChildItem $scriptDir\icons -Filter *.ico | Sort-Object -Property CreationTime;

# Abort if there are no *.ico files to embed!
# (windres.exe won't produce the compiled resource file otherwise.)
if ($icoFiles.Count -eq 0) {
    Write-Error "There are no *.ico files in the 'icons' directory!" -Category ResourceUnavailable;
    Exit;
}


# Generate a list of already embedded ICO files
[string[]] $icoList = @();
Get-Content "$scriptDir\resources.rc" -ErrorAction SilentlyContinue | Foreach {
    $_ -match ".* ICON `"(.*)`"" | Out-Null;
    $icoList += ($matches[1]);
}

# Go through all ico files in the list
# and produce the resource file.
#
# Output format:
#
# IC_[COUNTER]_[FILENAME] ICON [FILEPATH]
$newRcFile = "";
$icoFiles | Foreach {$i=0} {
    # Sanitize name and path
    $saveFileName = [IO.Path]::GetFileNameWithoutExtension($_.Name) -replace "[\W]", "";
    $fullFileName = getRelativePath -From $scriptDir -To ($_.FullName);

    # Only embed the found ICO file if it haven't been already included!
    if (-Not ($icoList.IndexOf($fullFileName) -eq -1)) {
        continue;
    }

    $resName = "IC_" + ($i+1) + "_" + $saveFileName;
    $newRcFile += $resName + " ICON `"" + $fullFileName + "`"";
    if ($i -lt ($icoFiles.Count-1)) {
        $newRcFile += "`r`n";
    }

    $i++;
}

$newRcFile | Set-Content "$scriptDir\resources.rc";

# Take the default path of MinGW bin's directory if it has been already installed.
# Otherwise take the MinGW directory downloaded into the script's directory.
$minGwBin = [IO.Path]::GetDirectoryName((Get-Command "mingw32-g++.exe" -ErrorAction SilentlyContinue | Select-Object Path | % { $_.Path }));
if (!$minGwBin) {
    $minGwBin = "$scriptDir\MinGw\bin";
    if (-Not(Test-Path($minGwBin))) {
        Write-Error "You have to install MinGW, either using the default installer provided on its website or with the minimal ZIP provided on the project page!";
        Exit;
    }
}

Start-Process "$minGwBin\windres.exe" ("-i `"$scriptDir\resources.rc`" -J rc -o `"$scriptDir\resources.res`" -O coff") -WorkingDirectory $scriptDir | Wait-Process;
# @todo Investigate a better solution than sleeping 1 second.
# The problem here is that 'resources.res' is not directly flushed onto the disk!
Start-Sleep -Milliseconds 1000;
Start-Process "$minGwBin\mingw32-g++.exe" ("-shared -Wl.--dll $scriptDir\resources.res -o `"$scriptDir\IcoHolder.dll`"") -WorkingDirectory $scriptDir | Wait-Process;