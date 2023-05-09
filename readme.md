This project includes a simple sandbox for load testing between two Virtual Machines that are connected via a Private Link.

You may use the botton below to deploy the environment to one resource group, or you can clone this repo and deploy through Azure Bicep via the main.bicep file.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjimgodden%2FPrivateLinkSandbox%2Fmain%2Fsrc%2Fmain.json)

Follow the steps below for testing:
1. Connect to the sourceVM with Bastion through the Azure Portal
2. Open a Powershell console (not Windows Powershell)
3. Run command "cd c:\\sourceTestingScript.ps1"

A PowerShell script will run that continously connects to the WebServer on the other end of the Private Endpoint.  The error is triggered when the source VM has to wait 10 seconds or more for a response to it's query.  The script will stop and output the time of the error in the console.

Wireshark is already installed on the machine during the initial setup.  However, Npcap needs to be installed manually.  You can run the installer for Npcap and Windows Terminal by running the following command in PowerShell:

"C:\\installTools.ps1"

Note: I have this same script in the same location on the destination VM as well.