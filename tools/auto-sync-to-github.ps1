param(
    [string]$RepoPath = "C:\dev\jewelry-with-code",
    [int]$IntervalSeconds = 5
)

$ErrorActionPreference = 'Continue'
$logPath = Join-Path $RepoPath 'auto-sync.log'

while ($true) {
    try {
        $status = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath status --porcelain --untracked-files=all 2>$null
        if ($status -and $status.ToString().Trim()) {
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Add-Content -Path $logPath -Value "[$timestamp] changes detected"
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath add -A | Out-Null
            $message = "chore: auto-sync $timestamp"
            $commitOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath commit -m $message 2>&1
            $pushOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath push origin main 2>&1
            Add-Content -Path $logPath -Value ($commitOutput | Out-String)
            Add-Content -Path $logPath -Value ($pushOutput | Out-String)
        }
    }
    catch {
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Add-Content -Path $logPath -Value "[$timestamp] error: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds $IntervalSeconds
}
