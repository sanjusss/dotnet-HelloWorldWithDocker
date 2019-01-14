﻿
$ErrorActionPreference = 'Stop';

if (!(Test-Path ~/.docker)) { mkdir ~/.docker }
# "$env:DOCKER_PASS" | docker login --username "$env:DOCKER_USER" --password-stdin
# docker login with the old config.json style that is needed for manifest-tool
$auth =[System.Text.Encoding]::UTF8.GetBytes("$($env:DOCKER_USER):$($env:DOCKER_PASS)")
$auth64 = [Convert]::ToBase64String($auth)
@"
{
  "auths": {
    "https://index.docker.io/v1/": {
      "auth": "$auth64"
    }
  },
  "experimental": "enabled"
}
"@ | Out-File -Encoding Ascii ~/.docker/config.json


docker tag local_image:${env:ARCH} ${env:REMOTE_IMAGE}:${env:ARCH}
docker push ${env:REMOTE_IMAGE}:${env:ARCH}

if ($env:ARCH -eq "amd64") {
    # The last in the build matrix
    docker -D manifest create "$($env:REMOTE_IMAGE):latest" `
        "$($env:REMOTE_IMAGE):arm32v7" `
        "$($env:REMOTE_IMAGE):arm64v8" `
        "$($env:REMOTE_IMAGE):amd64"
    docker manifest push "$($env:REMOTE_IMAGE):latest"
}