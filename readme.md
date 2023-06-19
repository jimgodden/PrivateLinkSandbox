This project includes a simple sandbox for load testing between two Virtual Machines that are connected via a Private Link.

You may use the botton below to deploy the environment to one resource group, or you can clone this repo and deploy through Azure Bicep via the main.bicep file.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjimgodden%2FPrivateLinkSandbox%2Fmain%2Fsrc%2Fmain.json)

Follow the steps below for testing:
1. Connect to the sourceVM with Bastion through the Azure Portal
2. Install npcap and Windows Terminal by running "c:\\installtools/ps1" in Windows PowerShell
3. Open Wireshark, start the packet capture, and use the following filter "tcp.port == 10001 and ip.addr != 10.1.2.4"
4. Open a Powershell console (not Windows Powershell) and run "cd c:\\sourceTestingScript.ps1"

A PowerShell script will run that continously connects to the WebServer on the other end of the Private Endpoint.  The error is triggered when the source VM has to wait 10 seconds or more for a response to it's query.  The script will stop and output the time of the error in the console.