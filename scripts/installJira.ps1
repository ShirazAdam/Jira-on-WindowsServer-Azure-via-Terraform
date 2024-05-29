$source = "https://download.oracle.com/java/22/latest/jdk-22_windows-x64_bin.exe"
$destination = "C:\Download\Java\jdk-22_windows-x64_bin.exe"
$client = new-object System.Net.WebClient 
$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie) 
$client.downloadFile($source, $destination)

.\$destination

$source = "https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-9.16.0-x64.exe"
$destination = "C:\Download\Java\atlassian-jira-software-9.16.0-x64.exe"
$client = new-object System.Net.WebClient 
$client.downloadFile($source, $destination)

.\$destination