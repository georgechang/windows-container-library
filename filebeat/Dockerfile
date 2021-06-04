ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG FILEBEAT_VERSION
ARG FILEBEAT_PACKAGE_URL=https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$FILEBEAT_VERSION-windows-x86_64.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
RUN Write-Host ('Installing Filebeat...'); \
	Write-Host ('Downloading {0}...' -f $env:FILEBEAT_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:FILEBEAT_PACKAGE_URL -OutFile 'filebeat.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive filebeat.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination C:\filebeat;

FROM mcr.microsoft.com/windows/nanoserver:${WINDOWS_VERSION}
COPY --from=builder ./filebeat /filebeat
COPY ./config/filebeat.yml /filebeat/filebeat.yml
USER ContainerAdministrator
WORKDIR /filebeat
ENTRYPOINT filebeat run --environment container