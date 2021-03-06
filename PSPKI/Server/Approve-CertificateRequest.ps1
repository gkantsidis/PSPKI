function Approve-CertificateRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({
			if ($_.GetType().FullName -eq "PKI.CertificateServices.DB.RequestRow") {$true} else {$false}
		})]$Request
	)
	process {
		if ((Ping-ICertAdmin $Request.ConfigString)) {
			$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
			try {
				$DM = $CertAdmin.ResubmitRequest($Request.ConfigString,$Request.RequestID)
				switch ($DM) {
					0 {Write-Warning "The request '$($Request.RequestID)' was not completed."}
					1 {Write-Warning "The request '$($Request.RequestID)' failed.'"}
					2 {Write-Warning "The request '$($Request.RequestID)' was denied."}
					3 {Write-Host "The certificate '$($Request.RequestID)' was issued.'" -ForegroundColor Green}
					4 {Write-Warning "The certificate '$($Request.RequestID)' was issued separately."} # not implemented
					5 {Write-Warning "The request '$($Request.RequestID)' was taken under submission."}
					default {
						$hresult = "0x" + $("{0:X2}" -f $DM)
						Write-Warning "The request with ID = '$($Request.RequestID)' was failed due to the error: $hresult"
					}
				}
			} catch {
				Write-Warning "Unable to issue request with ID = '$($Request.RequestID)'"; $_
			} finally {[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)}
		} else {Write-ErrorMessage -Source ICertAdminUnavailable -ComputerName $Request.ComputerName}
	}
}