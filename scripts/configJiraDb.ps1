[CmdLetbinding()]
param (
[string]$Server,
[string]$Username,
[string]$Password
)

If ($PSBoundParameters.Count < 3) {
	Write-Host "Not enough parameters"
	Read-Host
	exit
}

#deploy dbconfig.xml
.\${Jira-application-dir}\bin\config.bat $Server $Username $Password