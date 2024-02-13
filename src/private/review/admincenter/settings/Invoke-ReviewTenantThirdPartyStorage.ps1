function Invoke-ReviewTenantThirdPartyStorage
{
    <#
    .SYNOPSIS
        Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web'
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewTenantThirdPartyStorage;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Get settings.
        $settings = Get-TenantOfficeOnlineSetting;

        # Write to log.
        Write-Log -Category 'Tenant' -Subcategory 'Policy' -Message ("Allow third-party storage services is set to '{0}'" -f $settings.thirdPartyStorageEnabled) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If the review flag should be set.
        if ($true -eq $settings.thirdPartyStorageEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                       
        # Create new review object to return.
        [Review]$review = [Review]::new();
                               
        # Add to object.
        $review.Id = '54b612c6-5306-45d4-b948-f3e75e09ab3b';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web'";
        $review.Data = $settings.thirdPartyStorageEnabled;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();
                               
        # Return object.
        return $review;
    }
}