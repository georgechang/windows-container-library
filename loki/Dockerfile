ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG LOKI_VERSION=2.2.1
ARG LOKI_PACKAGE_URL=https://github.com/grafana/loki/releases/download/v$LOKI_VERSION/loki-windows-amd64.exe.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
RUN Write-Host ('Preparing Loki...'); \
	New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	Write-Host ('Downloading {0}...' -f $env:LOKI_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:LOKI_PACKAGE_URL -OutFile 'loki.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive loki.zip -DestinationPath C:\temp\; \
	Move-Item -Path C:\temp\loki-windows-amd64.exe -Destination C:\loki.exe;

FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION}
COPY --from=builder /loki.exe /loki/loki.exe
USER ContainerAdministrator
WORKDIR /loki
ENTRYPOINT ["loki.exe"]