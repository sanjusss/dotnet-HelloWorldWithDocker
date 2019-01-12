﻿
if (${env:ARCH} -eq "amd64") {
  docker build -t helloworld:${env:ARCH} --build-arg "runtime=3.0-runtime-stretch-slim" --build-arg "version=$env:APPVEYOR_BUILD_NUMBER" .
} else {
  docker build -t helloworld:${env:ARCH} --build-arg "runtime=3.0-runtime-stretch-slim-$env:ARCH" --build-arg "version=$env:APPVEYOR_BUILD_NUMBER" .
}