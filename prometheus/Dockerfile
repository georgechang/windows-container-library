ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG PROMETHEUS_VERSION=2.27.1
ARG PROMETHEUS_PACKAGE_URL=https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.windows-amd64.zip
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Write-Host ('Preparing Prometheus...'); \
	Write-Host ('Downloading {0}...' -f $env:PROMETHEUS_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:PROMETHEUS_PACKAGE_URL -OutFile 'prometheus.zip'; \
	Write-Host 'Expanding...'; \
	Expand-Archive prometheus.zip -DestinationPath C:\temp; \
	Move-Item -Path C:\temp\* -Destination C:\prometheus;

FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION}
COPY --from=builder ./prometheus /prometheus
COPY ./prometheus.yml /prometheus/prometheus.yml
EXPOSE 9090
USER ContainerAdministrator
WORKDIR /prometheus
ENTRYPOINT ["prometheus.exe", "--config.file=prometheus.yml"]