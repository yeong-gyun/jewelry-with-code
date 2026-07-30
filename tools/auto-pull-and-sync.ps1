param(
    [string]$RepoPath = "C:\dev\jewelry-with-code",
    [int]$IntervalSeconds = 10
)

$ErrorActionPreference = 'Continue'
$logPath = Join-Path $RepoPath 'auto-pull.log'

while ($true) {
    try {
        $remote = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath remote get-url origin 2>$null
        if ($LASTEXITCODE -ne 0) { throw 'remote not found' }

        $fetchOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath fetch origin main 2>&1
        $statusOutput = & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath status -sb 2>&1

        if ($statusOutput -match '\[ahead|behind|diverged]') {
            & 'C:\Program Files\Git\cmd\git.exe' -C $RepoPath pull --ff-only origin main 2>&1 | Out-Null
        }

        Add-Content -Path $logPath -Value ("[{0}] fetch/pull checked" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
    }
    catch {
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Add-Content -Path $logPath -Value ("[{0}] error: {1}" -f $timestamp, $_.Exception.Message)
    }

    Start-Sleep -Seconds $IntervalSeconds
}
