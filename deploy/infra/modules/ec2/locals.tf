locals {

    instance-userdata = <<EOF
        <powershell>
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'C:/Users/Administrator/dotnet-install.ps1'
            C:/Users/Administrator/dotnet-install.ps1 -Channel 8.0.x -InstallDir 'C:/Program Files/dotnet'
            [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\dotnet", "Machine")

            $s3Bucket = "build-artifacts-github-action"
            $s3Folder = "${var.app_name}/${var.app_version}/"
            $extractFolder = "C:/Api/"
            $downloadLocation = "C:/s3Contents"
            $objects = Get-S3Object -BucketName $s3Bucket -KeyPrefix $s3Folder
            foreach($object in $objects)
            {
                $localFileName = $object.Key
                if($localFileName -ne '')
                {
                    $downloadFile = Join-Path $downloadLocation $localFileName 
                    Copy-S3Object -BucketName $s3Bucket -Key $object.Key -LocalFile $downloadFile 
                    Expand-Archive $downloadFile -DestinationPath $extractFolder
                }
            }

            New-NetFirewallRule -DisplayName 'ALLOW TCP PORT 80' -Direction inbound -Profile Any -Action Allow -LocalPort 80 -Protocol TCP
            New-NetFirewallRule -DisplayName 'ALLOW TCP PORT 443' -Direction inbound -Profile Any -Action Allow -LocalPort 443 -Protocol TCP

            cd $extractFolder
            dotnet OpenWeatherForecast.Api.dll --urls "http://*:80"
        </powershell>
        <persist>true</persist>
    EOF
}