# 如何在Docker中运行普通.net core 命令行程序？
VS2017截至到15.8.3，仍然无法直接将.net core 命令行程序直接打包到docker镜像中。（难道微软程序员只用.net core写web吗？）  

随便新建一个.net core web(docker)项目，项目路径下会生成一个Dockerfile文件，如下：
```
FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY WebApplicationHelloWorld/WebApplicationHelloWorld.csproj WebApplicationHelloWorld/
RUN dotnet restore WebApplicationHelloWorld/WebApplicationHelloWorld.csproj
COPY . .
WORKDIR /src/WebApplicationHelloWorld
RUN dotnet build WebApplicationHelloWorld.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish WebApplicationHelloWorld.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebApplicationHelloWorld.dll"]
```
可以看到web项目是用dotnet命令编译生成的。
运行`dotnet restore --help`、`dotnet build --help`和`dotnet publish --help`查看相关命令用法。
我们的命令行程序也可以用dotnet命令生成发布：
```
FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY . /src
#RUN dotnet restore 
#RUN dotnet build  -c Release 
RUN dotnet publish -c Release -o /app

FROM microsoft/dotnet:2.1-runtime AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
```
这里使用了microsoft/dotnet:2.1-sdk 作为编译环境，microsoft/dotnet:2.1-runtime作为运行环境。这样打包后镜像体积会更小。  
如果需要进一步精简镜像，大家可以进一步删除/app中的无关文件。

# 编译示例
命令提示符或Power Shell下进入解决方案文件夹，输入：
```
docker build .
```
即可在本地得到生成的镜像。

# 运行本文示例
本文示例docker镜像地址 [点我](https://hub.docker.com/r/sanjusss/dotnet-helloworldwithdocker/)
```
docker run --rm sanjusss/dotnet-helloworldwithdocker
```
命令提示符下会显示
>Hello World!