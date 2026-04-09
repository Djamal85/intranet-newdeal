param(
    [Parameter(Mandatory = $true)]
    [string]$ImageRef
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$containerName = if ($env:CONTAINER_NAME) { $env:CONTAINER_NAME } else { "intranet-newdeal" }
$hostPort = if ($env:HOST_PORT) { $env:HOST_PORT } else { "80" }
$containerPort = if ($env:CONTAINER_PORT) { $env:CONTAINER_PORT } else { "80" }

Write-Host "[deploy] Pull de l'image $ImageRef"
docker pull $ImageRef

$existingContainer = docker ps -a --format "{{.Names}}" | Where-Object { $_ -eq $containerName }
if ($existingContainer) {
    Write-Host "[deploy] Suppression de l'ancien conteneur $containerName"
    docker rm -f $containerName
}

Write-Host "[deploy] Demarrage du nouveau conteneur $containerName"
docker run -d `
    --name $containerName `
    --restart unless-stopped `
    -p "${hostPort}:${containerPort}" `
    $ImageRef

Write-Host "[deploy] Verification de l'etat du conteneur"
docker ps --filter "name=$containerName" --filter "status=running"
