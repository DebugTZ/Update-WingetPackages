# Check required module
$RequiredModule = "Microsoft.WinGet.Client"

# Installieren, wenn nicht vorhanden
if (-not (Get-Module -ListAvailable -Name $RequiredModule)) {
    Write-Host "Das benötigte Modul $RequiredModule ist nicht installiert." -ForegroundColor DarkYellow
    Write-Host "Installiere das benötigte Modul $RequiredModule..."
    try {
        Install-Module $RequiredModule -AcceptLicense -Force -ErrorAction Stop
    } catch {
        Write-Host "Fehler bei der Installation des Moduls: $_" -ForegroundColor Red
        exit 1
    }
}

# Winget-Modul importieren
try {
    Import-Module $RequiredModule -ErrorAction Stop
} catch {
    Write-Host "Fehler beim Importieren des Moduls: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Winget Version: $(Get-WinGetVersion)"
Write-Host "Suche nach installierten Paketen..."
# Installierte Pakete finden
$InstalledPackages = Get-WinGetPackage
# Ausnahmen festlegen
$Exceptions = @("WavesAudio.WavesCentral", "Weitere.ID")

# Jedes Paket auf Updates prüfen und aktualisieren
foreach($Package in $InstalledPackages){
    if ($Package.Id -notin $Exceptions) {
        Write-Host "Prüfe Update für $($Package.Name)..."
        try {
            Update-WinGetPackage $Package -Mode Silent -ErrorAction Stop
            Write-Host "$($Package.Name) ist aktuell." -ForegroundColor DarkGreen
        } catch {
            Write-Host "Fehler beim Aktualisieren von $($Package.Name): $_" -ForegroundColor Red
        }
    } else {
        Write-Host "$($Package.Name) ist in der Ausnahmeliste und wird übersprungen." -ForegroundColor DarkYellow
    }
}
