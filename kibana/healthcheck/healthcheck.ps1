try {
	$response = Invoke-WebRequest http://localhost:5601/api/status -TimeoutSec 5
	if ($response.StatusCode -eq 200) {
		$content = ConvertFrom-Json $response.Content
		if ($content.status.overall.state -eq "green") {
			exit 0
		}
		exit 1
	}
	exit 1
}
catch { exit 1 }