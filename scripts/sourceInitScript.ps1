# Download and install the PowerShell Core package
Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/PowerShell-7.2.1-win-x64.msi -OutFile PowerShell-7.2.1-win-x64.msi
Start-Process msiexec.exe -Wait -ArgumentList '/i PowerShell-7.2.1-win-x64.msi /qn /norestart'

# Add the PowerShell Core executable path to the system PATH environment variable
$envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$psCorePath = 'C:\Program Files\PowerShell\7'
if ($envPath -notlike "*$psCorePath*") {
    [Environment]::SetEnvironmentVariable('Path', "$envPath;$psCorePath", 'Machine')
}

# Download and install the test script and place it in the c:\ drive
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jimgodden/PrivateLinkSandbox/main/scripts/sourceTestingScript.ps1" -OutFile "c:\sourceTestingScript.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jimgodden/PrivateLinkSandbox/main/scripts/installWireshark.ps1" -OutFile "c:\installWireshark.ps1"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jimgodden/PrivateLinkSandbox/main/scripts/withoutNetSH.ps1" -OutFile "c:\withoutNetSH.ps1"

# $taskName = "Test Script Runner"
# $taskDescription = "Runs sourceTestingScript.ps1 with argument '1' on login"
# $scriptFilePath = "C:\sourceTestingScript.ps1" # Set the file path to your aaoof.ps1 file here
# $minutes = [int](Get-Date -Format "mm")
# $futureMinutes = $minutes + 5
# $futureTimeFull = Get-Date -Format "HH:${futureMinutes}tt"

# # Create a new Task Scheduler trigger for weekdays at 4 PM
# $trigger = New-ScheduledTaskTrigger -Once -At $futureTimeFull

# # Create a new Task Scheduler action to run PowerShell with the script and argument
# $action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "${scriptFilePath} 1"

# # Register the task with Task Scheduler
# Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $taskDescription