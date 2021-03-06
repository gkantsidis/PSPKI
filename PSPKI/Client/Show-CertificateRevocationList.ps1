function Show-CertificateRevocationList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Security.Cryptography.X509Certificates.X509CRL2]$CRL
	)
	
	process {
		if (!$CRL.Handle.Equals([IntPtr]::Zero)) {
			[PKI.ManagedAPI.ManagedCryptUI]::DisplayCRL($CRL.Handle)
		} else {
			Write-Error -Category ResourceUnavailable -ErrorId "InvalidHandleException" `
			-Message "An attempt was made to access an uninitialized object. The handle is invalid."
		}
	}
}