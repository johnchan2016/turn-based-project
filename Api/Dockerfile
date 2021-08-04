# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY turn-based-api/*.csproj ./turn-based-api/
RUN dotnet restore

# copy everything else and build app
COPY turn-based-api/. ./turn-based-api/
WORKDIR /source/turn-based-api
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app

# run env if any
ARG BUILD_CONFIGURATION=Debug
ENV ASPNETCORE_ENVIRONMENT=Development
ENV DOTNET_USE_POLLING_FILE_WATCHER=true  
ENV ASPNETCORE_URLS=http://+:80;https://+:5001;http://+:5000
EXPOSE 80 5000 5001

COPY --from=build /app ./
ENTRYPOINT ["dotnet", "turn-based-api.dll"]
# ENTRYPOINT ["dotnet", "turn-based-api.dll", "--urls", "https://0.0.0.0:5000"]
