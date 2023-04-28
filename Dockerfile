# Base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

RUN apt-get update && apt-get install -y curl
WORKDIR /app
COPY --from=build /app/out ./

ENTRYPOINT ["dotnet", "testSoftwarePractices.dll"]
