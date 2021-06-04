ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG EXPORTER_VERSION=0.16.0
ARG EXPORTER_PACKAGE_URL=https://github.com/prometheus-community/windows_exporter/releases/download/v$EXPORTER_VERSION/windows_exporter-$EXPORTER_VERSION-amd64.exe
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN New-Item -ItemType Directory -Path C:\prometheus | Out-Null; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
RUN Write-Host ('Installing Prometheus Windows Exporter...'); \
	Write-Host ('Downloading {0}...' -f $env:EXPORTER_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:EXPORTER_PACKAGE_URL -OutFile 'windows_exporter.msi'; \
	Move-Item -Path windows_exporter.exe -Destination C:\prometheus\windows_exporter.msi;

FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION}
COPY --from=builder ./prometheus /prometheus
USER ContainerAdministrator
WORKDIR /prometheus
RUN msiexec /i .\windows_exporter.msi ENABLED_COLLECTORS=cpu,cs,container,logical_disk,memory,net,os,service