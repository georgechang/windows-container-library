ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG GRAFANA_VERSION=7.5.7
ARG GRAFANA_PACKAGE_URL=https://dl.grafana.com/oss/release/grafana-$GRAFANA_VERSION.windows-amd64.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Write-Host ('Preparing Grafana...'); \
	Write-Host ('Downloading {0}...' -f $env:GRAFANA_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:GRAFANA_PACKAGE_URL -OutFile 'grafana.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive grafana.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination C:\grafana;

FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION}
COPY --from=builder ./grafana /grafana
EXPOSE 3000
USER ContainerAdministrator
WORKDIR /grafana
ENTRYPOINT ["bin/grafana-server.exe"]