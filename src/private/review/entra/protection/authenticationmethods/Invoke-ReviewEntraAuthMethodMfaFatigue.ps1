function Invoke-ReviewEntraAuthMethodMfaFatigue
{
    <#
    .SYNOPSIS
        If Microsoft Authenticator is configured to protect against MFA fatigue.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodMfaFatigue;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message ("Getting authentication methods") -Level Debug;

        # Get authentication method policy.
        $authenticationMethodPolicy = Get-MgPolicyAuthenticationMethodPolicy;
        
        # Valid configuration.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # Foreach authentication method configuration.
        foreach ($authenticationMethodConfiguration in $authenticationMethodPolicy.AuthenticationMethodConfigurations)
        {
            # Skip if not "MicrosoftAuthenticator".
            if ($authenticationMethodConfiguration.id -ne 'MicrosoftAuthenticator')
            {
                # Skip to next item.
                continue;
            }

            # If state is disabled.
            if ($authenticationMethodConfiguration.state -eq 'disabled')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Microsoft Authenticator authentication method is disabled' -Level Debug;

                # Skip to next item.
                continue;
            }

            # Microsoft Authenticator.
            $microsoftAuthenticator = $authenticationMethodConfiguration;

            # Get feature settings for "Show application name in push and passwordless notifications".
            $displayAppInformationRequiredState = $microsoftAuthenticator.AdditionalProperties.featureSettings.displayAppInformationRequiredState;
            
            # If display app information required state is "disabled".
            if ($displayAppInformationRequiredState.state -eq 'disabled')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show application name in push and passwordless notifications, is not enabled' -Level Debug;

                # Skip to next item.
                continue;
            }

            # If display app information required state is not deployed to all users.
            if (($displayAppInformationRequiredState.includeTarget).Values -notcontains 'all_users')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show application name in push and passwordless notifications, is not deployed to all users' -Level Debug;

                # Skip to next item.
                continue;
            }

            # Get feature settings for "Show geographic location in push and passwordless notifications".
            $displayLocationInformationRequiredState = $microsoftAuthenticator.AdditionalProperties.featureSettings.displayLocationInformationRequiredState;

            # If display location app information required state is "disabled".
            if ($displayLocationInformationRequiredState.state -eq 'disabled')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show geographic location in push and passwordless notifications, is not enabled' -Level Debug;

                # Skip to next item.
                continue;
            }

            # If display location app information required state is not deployed to all users.
            if (($displayLocationInformationRequiredState.includeTarget).Values -notcontains 'all_users')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show geographic location in push and passwordless notifications, is not deployed to all users' -Level Debug;

                # Skip to next item.
                continue;
            }

            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message ("The authentication method policy '{0}' is valid" -f $authenticationMethodConfiguration.Id) -Level Debug;

            # Set valid configuration.
            $valid = $true;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = '0c1ccf40-64f3-4300-96e4-2f7f3272bf9a';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = 'Ensure Microsoft Authenticator is configured to protect against MFA fatigue';
        $review.Data = $authenticationMethodPolicy.AuthenticationMethodConfigurations;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}