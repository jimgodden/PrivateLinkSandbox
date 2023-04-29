# This file will be used for testing purposes until a proper CI/CD pipeline is in place.  Delete ASAP

$start = get-date -UFormat "%s"

$currentTime = Get-Date -Format "HH:mm K"
Write-Host "Starting Bicep Deployment.  Process began at: ${currentTime}"

# Specifies the account and subscription where the deployment will take place.
Set-AzContext -Subscription "a2c8e9b2-b8d3-4f38-8a72-642d0012c518"

$iteration = 1
$rgLocation = "westeurope"

for ($iteration = 1; $iteration -le 10; $iteration++) {
    $rgName = "VFP_Test_${rgLocation}_${iteration}"
    Write-Host "Creating ${rgName}"
    New-AzResourceGroup -Name $rgName -Location $rgLocation

    Write-Host "`nStarting Bicep Deployment.."
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateParameterFile ".\main.parameters.json" -TemplateFile ".\main.bicep" -iteration $iteration # -whatif
}


$end = get-date -UFormat "%s"
$timeTotalSeconds = $end - $start
$timeTotalMinutes = $timeTotalSeconds / 60
$currentTime = Get-Date -Format "HH:mm K"
Write-Host "Process finished at: ${currentTime}"
Write-Host "Total time taken in seconds: ${timeTotalSeconds}"
Write-Host "Total time taken in minutes: ${timeTotalMinutes}"
Read-Host "`nPress any key to exit.."