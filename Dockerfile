FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY . /src
RUN dotnet restore 
RUN dotnet build  -c Release 
RUN dotnet publish -c Release -o /app

FROM microsoft/dotnet:2.1-runtime AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
