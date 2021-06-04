ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG KIBANA_VERSION
ARG KIBANA_PACKAGE_URL=https://artifacts.elastic.co/downloads/kibana/kibana-$KIBANA_VERSION-windows-x86_64.zip
ARG POWERSHELL_VERSION=7.1.3
ARG POWERSHELL_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/PowerShell-$POWERSHELL_VERSION-win-x64.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
# Need to add PowerShell to run healthchecks
RUN Write-Host ('Preparing PowerShell...'); \
	New-Item -ItemType Directory -Path C:\pstemp | Out-Null; \
	Write-Host ('Downloading {0}...' -f $env:POWERSHELL_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:POWERSHELL_PACKAGE_URL -OutFile 'powershell.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive powershell.zip -DestinationPath C:\pstemp; \
	Move-Item -Path C:\pstemp\* -Destination C:\powershell;
RUN Write-Host ('Preparing Kibana...'); \
	New-Item -ItemType Directory -Path C:\kibtemp | Out-Null; \
	Write-Host ('Downloading {0}...' -f $env:KIBANA_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:KIBANA_PACKAGE_URL -OutFile 'kibana.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive kibana.zip -DestinationPath C:\kibtemp; \
	Move-Item -Path C:\kibtemp\* -Destination C:\kibana;

FROM mcr.microsoft.com/windows/nanoserver:${WINDOWS_VERSION}
ENV ProgramFiles="C:\Program Files" 
COPY --from=builder ["./powershell", "$ProgramFiles/PowerShell"]
COPY --from=builder ./kibana /kibana
COPY ./config/kibana.yml /kibana/config/kibana.yml
COPY ./healthcheck /healthcheck
EXPOSE 5601
USER ContainerAdministrator
RUN setx PATH "%PATH%;%ProgramFiles%\PowerShell;" /M
ENTRYPOINT ["/kibana/bin/kibana.bat"]