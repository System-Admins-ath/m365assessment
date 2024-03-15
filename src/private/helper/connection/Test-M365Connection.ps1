function Test-M365Connection
{
    <#
    .SYNOPSIS
        Test login to various Microsoft services.
    .DESCRIPTION
        Invoke differrent endpoints to check connectivity to Microsoft 365 services such as Entra ID, SharePoint, Exchange, Fabric etc.
    .NOTES
        Requires the following modules:
        - Az.Accounts
        - ExchangeOnlineManagement
        - Microsoft.Graph.Authentication
        - MicrosoftTeams
        - PnP.PowerShell
    .EXAMPLE
        # Test login to Microsoft services.
        Test-M365Connection;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Hash table for connections.
        [hashtable]$connections = @{};

        # Microsoft Graph.
        $connections.Add('Graph', $false);

        # Azure.
        $connections.Add('Azure', $false);

        # Exchange Online.
        $connections.Add('ExchangeOnline', $false);

        # Microsoft Teams.
        $connections.Add('Teams', $false);

        # SharePoint.
        $connections.Add('SharePoint', $false);
    }
    PROCESS
    {
        # Try to connect to Microsoft services.
        try
        {
            # Test connection to Microsoft Graph.
            $null = Get-MgContext -ErrorAction Stop;
            $connections.Graph = $true;
        }
        catch
        {
        }
        
        # Try to connect to Azure.
        try
        {
            # Test connection to Azure.
            $null = Get-AzAccessToken -ErrorAction Stop;
            $connections.Azure = $true;
        }
        catch
        {
        }

        # Try to connect to Exchange Online.
        try
        {
            # Test connection to Exchange Online.
            $null = Get-AcceptedDomain -ErrorAction Stop;
            $connections.ExchangeOnline = $true;
        }
        catch
        {
            <#Do this if a terminating exception happens#>
        }

        # Try to connect to Microsoft Teams.
        try
        {
            # Test connection to Microsoft Teams.
            $null = Get-TeamsProtectionPolicy -ErrorAction Stop;
            $connections.Teams = $true;
        }
        catch
        {
        }

        # Try to connect to SharePoint.
        try
        {
            # Test connection to SharePoint.
            $null = Get-PnPTenant -ErrorAction Stop;
            $connections.SharePoint = $true;
        }
        catch
        {
        }
    }
    END
    {
        # Return connections.
        return $connections;
    }
}