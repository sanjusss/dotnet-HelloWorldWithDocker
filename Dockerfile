
ARG runtime=microsoft/dotnet:3.0-runtime
ARG version=0

FROM microsoft/dotnet:3.0-sdk AS build
MAINTAINER sanjusss <sanjusss@qq.com>
WORKDIR /src
COPY . /src
RUN dotnet publish -c Release -o /app --version-suffix=$version ./HelloWorld/HelloWorld.csproj

FROM $runtime AS final
MAINTAINER sanjusss <sanjusss@qq.com>
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
