try {
	$response = Invoke-WebRequest http://localhost:9200/_cluster/health -TimeoutSec 5
	if ($response.StatusCode -eq 200) {
		$content = ConvertFrom-Json $response.Content
		if ($content.status -eq "green") {
			exit 0
		}
		exit 1
	}
	exit 1
}
catch { exit 1 }