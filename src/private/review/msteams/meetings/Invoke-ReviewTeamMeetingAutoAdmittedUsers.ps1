function Invoke-ReviewTeamMeetingAutoAdmittedUsers
{
    <#
    .SYNOPSIS
        Review only people in my org can bypass the lobby.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingAutoAdmittedUsers;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ('Getting meeting policies') -Level Debug;

        # Get meeting policy.
        $meetingPolicy = Get-CsTeamsMeetingPolicy -Identity Global;

        # Valid flag.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If only people in my org can bypass the lobby.
        if ($meetingPolicy.AutoAdmittedUsers -eq 'EveryoneInCompanyExcludingGuests')
        {
            # Set valid flag.
            $valid = $true;
        }

        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Auto admit users is set to '{0}'" -f $meetingPolicy.AutoAdmittedUsers) -Level Debug;
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
        $review.Id = '5252f126-4d4e-4a1c-ab56-743f8efe2b3e';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Meetings';
        $review.Title = "Ensure only people in my org can bypass the lobby";
        $review.Data = $meetingPolicy.AutoAdmittedUsers;
        $review.Review = $reviewFlag;
                                      
        # Print result.
        $review.PrintResult();
                                                     
        # Return object.
        return $review;
    } 
}