# .NET 9
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

# Restore the project
COPY *.sln .
COPY *.csproj ./
RUN dotnet restore

# Build / Publish
COPY . .
RUN dotnet publish -c release --property:PublishDir=/app

# Final Container
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "NowPlaying.dll"]