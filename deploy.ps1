
docker login -u="$env:DOCKER_USER" -p="$env:DOCKER_PASS"
docker tag helloworld:${env:ARCH} sanjusss/dotnet-helloworldwithdocker:${env:ARCH}
docker push sanjusss/dotnet-helloworldwithdocker:${env:ARCH}

if ($env:ARCH -eq "amd64") {
    # The last in the build matrix
    docker -D manifest create "sanjusss/dotnet-helloworldwithdocker:latest" `
        "sanjusss/dotnet-helloworldwithdocker:arm32v7" `
        "sanjusss/dotnet-helloworldwithdocker:arm64v8" `
        "sanjusss/dotnet-helloworldwithdocker:amd64"
    docker manifest annotate "sanjusss/dotnet-helloworldwithdocker:latest" "sanjusss/dotnet-helloworldwithdocker:arm32v7" --os linux --arch arm --variant v7
    docker manifest annotate "sanjusss/dotnet-helloworldwithdocker:latest" "sanjusss/dotnet-helloworldwithdocker:arm64v8:APPVEYOR_REPO_TAG_NAME" --os linux --arch arm64 --variant v8
    docker manifest push "sanjusss/dotnet-helloworldwithdocker:latest"
}