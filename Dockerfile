FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY blazorapp/blazorapp.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish  "blazorapp/blazorapp.csproj" -c Release -o out

# Build runtime image
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=build-env /app/out/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf