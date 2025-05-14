# Clean the repo from .terraform and force push to GitHub

$repoPath = Get-Location
$filterRepoExe = "$repoPath\git-filter-repo.exe"
$filterRepoUrl = "https://github.com/newren/git-filter-repo/releases/latest/download/git-filter-repo.exe"

# Check if git-filter-repo.exe exists
if (-Not (Test-Path $filterRepoExe)) {
    Write-Host "Downloading git-filter-repo.exe ..."
    Invoke-WebRequest -Uri $filterRepoUrl -OutFile $filterRepoExe
} else {
    Write-Host "git-filter-repo.exe already exists"
}

# Run the cleanup
Write-Host "Starting to clean the repo from .terraform ..."
& $filterRepoExe --path .terraform --invert-paths

# Clean old history and optimize
Write-Host "Running git gc and git reflog ..."
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push the clean history to GitHub
Write-Host "Force pushing the cleaned repo to GitHub ..."
git push origin --force

Write-Host "DONE: The repo is now clean and pushed successfully!"
