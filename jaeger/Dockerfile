ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION} as builder
ARG JAEGER_VERSION=1.22.0
ARG JAEGER_PACKAGE_URL=https://github.com/jaegertracing/jaeger/releases/download/v$JAEGER_VERSION/jaeger-$JAEGER_VERSION-windows-amd64.tar.gz
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
RUN Write-Host ('Preparing Jaeger...'); \
	New-Item -ItemType Directory -Path C:\temp | Out-Null; \
	Write-Host ('Downloading {0}...' -f $env:JAEGER_PACKAGE_URL); \
	Invoke-WebRequest -Uri $env:JAEGER_PACKAGE_URL -OutFile 'jaeger.zip'; \
	Write-Host 'Expanding...'; \
	tar -xvzf jaeger.zip -C C:\temp; \
	Move-Item -Path C:\temp\* -Destination C:\jaeger;

FROM mcr.microsoft.com/windows/servercore:${WINDOWS_VERSION}
COPY --from=builder ./jaeger /jaeger
EXPOSE 5775 6831 6832 5778 16686 14268 14250 9411
USER ContainerAdministrator
WORKDIR /jaeger
ENTRYPOINT ["jaeger-all-in-one.exe"]