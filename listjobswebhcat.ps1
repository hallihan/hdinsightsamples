if(!$ClusterCredential) { $ClusterCredential = Get-Credential }
$ClusterName = 'clustername'

$Jobs = Invoke-RestMethod -Uri "https://$ClusterName.azurehdinsight.net/templeton/v1/jobs?user.name=$($ClusterCredential.UserName)&showall=true" -Credential $ClusterCredential
Write-Host 'The following job information was retrieved:`n'
$Jobs | ft

foreach($JobId in $Jobs.id)
{
    $Job = Invoke-RestMethod -Uri "https://$ClusterName.azurehdinsight.net/templeton/v1/jobs/$JobId`?user.name=$($ClusterCredential.UserName)" -Credential $ClusterCredential
    Write-Host "The following details were retrieved for JobId $JobId`:`n"
    $Job | ft
    # Powershell doesn't like the fact that the response includes jobId and jobID tags, so I'm going to modify the one that contains a Hash.
    # Invoke-RestMethod would have automatically converted the JSON to a PSObject if thow two tags hadn't been there, so post-convering.
    $Job = convertfrom-json ($Job -creplace 'jobID','jobIDObj')
    Write-Host "`nThe following is the parsed Status for JobId $JobId`:"
    $Job.status | fl
    Write-Host "-------------------------------------------------------"
    
}