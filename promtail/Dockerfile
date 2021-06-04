ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG PROMTAIL_VERSION
ARG PROMTAIL_PACKAGE_URL=https://github.com/grafana/loki/releases/download/v$PROMTAIL_VERSION/promtail-windows-amd64.exe.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
RUN Write-Host ('Preparing Promtail...'); \
	New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	Write-Host ('Downloading {0}...' -f $env:PROMTAIL_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:PROMTAIL_PACKAGE_URL -OutFile 'promtail.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive promtail.zip -DestinationPath C:\temp\; \
	Move-Item -Path C:\temp\promtail-windows-amd64.exe -Destination C:\promtail.exe;

FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION}
COPY --from=builder /promtail.exe /promtail/promtail.exe
COPY ./config.yaml /promtail/config.yaml
USER ContainerAdministrator
ENTRYPOINT ["/promtail/promtail.exe"]