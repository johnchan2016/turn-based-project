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

COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
