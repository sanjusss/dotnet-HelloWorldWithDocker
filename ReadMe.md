# �����Docker��������ͨ.net core �����г���
VS2017������15.8.3����Ȼ�޷�ֱ�ӽ�.net core �����г���ֱ�Ӵ����docker�����С����ѵ�΢�����Աֻ��.net coreдweb�𣿣�  

����½�һ��.net core web(docker)��Ŀ����Ŀ·���»�����һ��Dockerfile�ļ������£�
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
���Կ���web��Ŀ����dotnet����������ɵġ�
����`dotnet restore --help`��`dotnet build --help`��`dotnet publish --help`�鿴��������÷���
���ǵ������г���Ҳ������dotnet�������ɷ�����
```
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
```
����ʹ����microsoft/dotnet:2.1-sdk ��Ϊ���뻷����microsoft/dotnet:2.1-runtime��Ϊ���л����������������������С��  
�����Ҫ��һ�������񣬴�ҿ��Խ�һ��ɾ��/app�е��޹��ļ���

# ����ʾ��
������ʾ����Power Shell�½����������ļ��У����룺
```
docker build .
```

# ���б���ʾ��
```
docker run --rm sanjusss/dotnet-helloworldwithdocker
```
������ʾ���»���ʾ
>Hello World!