
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


docker tag helloworld:${env:ARCH} sanjusss/dotnet-helloworldwithdocker:${env:ARCH}
docker push sanjusss/dotnet-helloworldwithdocker:${env:ARCH}

if ($env:ARCH -eq "amd64") {
    # The last in the build matrix
    docker -D manifest create "sanjusss/dotnet-helloworldwithdocker:latest" `
        "sanjusss/dotnet-helloworldwithdocker:arm32v7" `
        "sanjusss/dotnet-helloworldwithdocker:arm64v8" `
        "sanjusss/dotnet-helloworldwithdocker:amd64"
    docker manifest push "sanjusss/dotnet-helloworldwithdocker:latest"
}