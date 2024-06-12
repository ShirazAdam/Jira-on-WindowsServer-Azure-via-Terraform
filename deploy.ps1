# PowerShell script to install Jira on Windows

# Install Chocolatey (package manager for Windows)
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install OpenJDK 11
choco install openjdk11 -y

# Download and Install Jira
$jiraInstallerUrl = "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-9.16.0-x64.exe"
$jiraInstallerPath = "C:\atlassian-jira-software-9.16.0-x64.exe"

Invoke-WebRequest -Uri $jiraInstallerUrl -OutFile $jiraInstallerPath
Start-Process -FilePath $jiraInstallerPath -ArgumentList "/S" -Wait

#[CmdLetbinding()]
#param (
#[string]$Server,
#[string]$Username,
#[string]$Password
#)

#If ($PSBoundParameters.Count < 3) {
#	Write-Host "Not enough parameters"
#	Read-Host
#	exit
#}

#deploy dbconfig.xml
#.\${Jira-application-dir}\bin\config.bat $Server $Username $Password

# Configure Jira to start automatically
sc.exe create "Jira" binPath= "\"C:\Program Files\Atlassian\Jira\bin\start-jira.bat\""
sc.exe start "Jira"
