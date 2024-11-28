# .NET 9
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

# Restore the project
COPY *.sln .x§x§
COPY *.csproj ./
RUN dotnet restore

# Build / Publish
COPY . .
RUN dotnet publish -c release --property:PublishDir=/app
RUN dotnet tool install --global dotnet-ef --version 9.*
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet ef database update

# Final Container
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app ./
COPY --from=build /source/nowplaying.db ./
ENTRYPOINT ["dotnet", "NowPlaying.dll"]