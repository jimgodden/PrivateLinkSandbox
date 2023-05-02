This project includes a simple sandbox for load testing between two Virtual Machines that are connected via a Private Link.

You use the botton below to deploy the environment to one resource group.  Let me know if you need a script to deploy many of these environments at once.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjimgodden%2FPrivateLinkSandbox%2Fmain%2Fsrc%2Fmain.json)

Follow the steps below for testing:
1. Connect to the sourceVM with Bastion through the Azure Portal
2. Open a Powershell console (not Windows Powershell)
3. Run command "cd c:\\"
4. Run command ".\\sourceTestingScript.ps1"
