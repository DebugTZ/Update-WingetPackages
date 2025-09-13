# Check required module
$RequiredModule = "Microsoft.WinGet.Client"

# Install if not installed
if(!(get-module $RequiredModule)){
    Write-Host "Das benötigte Modul $RequiredModule ist nicht installiert." -ForegroundColor DarkYellow
    Write-Host "Installiere das benötigte Modul $RequiredModule..."

    Install-Module $RequiredModule -AcceptLicense -Force
}

# Winget-Modul importieren
Import-Module $RequiredModule

Write-Host "Winget Version: $(Get-WinGetVersion)"
Write-Host "Suche nach installierten Paketen..."
# Installierte Pakete finden
$InstalledPackages = Get-WinGetPackage
# Ausnahmen festlegen
$Exceptions = @("WavesAudio.WavesCentral", "Weitere.ID")

# Jedes Paket auf Updates prüfen und aktualisieren
foreach($Package in $InstalledPackages){
    if($Package.id -notin $Exceptions){
        Update-WinGetPackage $Package -Mode Silent
    }
}
