ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG METRICBEAT_VERSION
ARG POWERSHELL_VERSION=7.1.3
ARG METRICBEAT_PACKAGE_URL=https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$METRICBEAT_VERSION-windows-x86_64.zip
ARG POWERSHELL_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/PowerShell-$POWERSHELL_VERSION-win-x64.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
RUN Write-Host ('Preparing Metricbeat...'); \
	Write-Host ('Downloading {0}...' -f $env:METRICBEAT_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:METRICBEAT_PACKAGE_URL -OutFile 'metricbeat.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive metricbeat.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination C:\metricbeat;

FROM mcr.microsoft.com/windows/nanoserver:${WINDOWS_VERSION}

COPY --from=builder ./metricbeat /metricbeat
COPY ./config/metricbeat.yml /metricbeat/metricbeat.yml
COPY ./modules.d/* /metricbeat/modules.d/
USER ContainerAdministrator
WORKDIR /metricbeat
ENTRYPOINT metricbeat run --environment container