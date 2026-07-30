param(
  [string]$RepoPath = (Resolve-Path (Join-Path $PSScriptRoot ".."))
)

Set-Location $RepoPath

git config --local user.name "Copilot Auto Sync"
git config --local user.email "copilot-auto-sync@example.com"

while ($true) {
  $status = git status --porcelain
  if ($status) {
    Start-Sleep -Seconds 3
    $statusAfter = git status --porcelain
    if ($statusAfter) {
      $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
      git add -A
      git commit -m "chore: auto-sync $stamp" | Out-Null
      git pull --ff-only origin main | Out-Null
      git push origin HEAD:main | Out-Null
      Write-Host "Auto-sync completed at $stamp"
    }
  }
  Start-Sleep -Seconds 2
}
