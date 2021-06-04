ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG ELASTICSEARCH_VERSION
ARG ELASTICSEARCH_PACKAGE_URL=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION-windows-x86_64.zip
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
RUN Write-Host ('Preparing Elasticsearch...'); \
	New-Item -ItemType Directory -Path C:\estemp | Out-Null; \
	Write-Host ('Downloading {0}...' -f $env:ELASTICSEARCH_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:ELASTICSEARCH_PACKAGE_URL -OutFile 'elasticsearch.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive elasticsearch.zip -DestinationPath C:\estemp; \
	Move-Item -Path C:\estemp\* -Destination C:\elasticsearch;

FROM mcr.microsoft.com/windows/nanoserver:${WINDOWS_VERSION}
ENV ProgramFiles="C:\Program Files" 
COPY --from=builder ["./powershell", "$ProgramFiles/PowerShell"]
COPY --from=builder ./elasticsearch /elasticsearch
COPY ./config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml
COPY ./healthcheck /healthcheck
EXPOSE 9200 9300
USER ContainerAdministrator
RUN setx PATH "%PATH%;%ProgramFiles%\PowerShell;" /M
ENTRYPOINT ["/elasticsearch/bin/elasticsearch.bat"]