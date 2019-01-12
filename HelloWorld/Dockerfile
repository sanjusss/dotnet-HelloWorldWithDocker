FROM microsoft/dotnet:3.0-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:3.0-sdk AS build
WORKDIR /src
COPY HelloWorld/HelloWorld.csproj HelloWorld/
RUN dotnet restore HelloWorld/HelloWorld.csproj
COPY . .
WORKDIR /src/HelloWorld
RUN dotnet build HelloWorld.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish HelloWorld.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
