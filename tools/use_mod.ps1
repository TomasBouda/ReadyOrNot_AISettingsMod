if((Test-Path -Path "$PSScriptRoot\use_mod_path.txt")) {
    $modsDir = Get-Content -Path "$PSScriptRoot\use_mod_path.txt" -Encoding UTF8
    Write-Host "Mod path found: $modsDir"

    Copy-Item -Path "$PSScriptRoot\..\src\pakchunk99-AISettings_P.pak" -Destination $modsDir -Force
    exit
}

Write-Host "Searching for SteamLibrary folders..."

$drives = Get-PSDrive -PSProvider 'FileSystem'

foreach ($drive in $drives) {
    # Searcg for SteamLibrary
    $steamLibraryPaths = Get-ChildItem -Path ($drive.Name + ":\") -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object {
        $_.PSIsContainer -and $_.Name -eq "SteamLibrary"
    }

    if($null -ne $steamLibraryPaths) {
        $steamLibPath = $steamLibraryPaths | Select-Object -First 1
        $paksDir = Join-Path -Path $steamLibPath.FullName -ChildPath "steamapps\common\Ready Or Not\ReadyOrNot\Content\Paks"
        $modsDir = Get-Item -Path "$paksDir\mymods"
        if($null -eq $modsDir) {
            $modsDir = New-Item -Path "$paksDir\mymods" -ItemType "Directory" -ErrorAction SilentlyContinue
        }
        $modsDir.FullName | Out-File -FilePath "$PSScriptRoot\use_mod_path.txt" -Encoding UTF8
        Write-Host "Mod path set to: $($modsDir.FullName)"

        Copy-Item -Path "$PSScriptRoot\..\src\pakchunk99-AISettings_P.pak" -Destination $modsDir.FullName -Force
        break
    }
}