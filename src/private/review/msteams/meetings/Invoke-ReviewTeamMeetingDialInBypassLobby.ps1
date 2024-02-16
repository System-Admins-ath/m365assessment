function Invoke-ReviewTeamMeetingDialInBypassLobby
{
    <#
    .SYNOPSIS
        Review if users dialing in can't bypass the lobby.
     .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingDialInBypassLobby;
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
        # If users dialing in can't bypass the lobby.
        if ($meetingPolicy.AllowPSTNUsersToBypassLobby -eq $false)
        {
            # Set valid flag.
            $valid = $true;
        }

        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Dialin users are allowed to bypass lobby is set to '{0}'" -f $meetingPolicy.AllowPSTNUsersToBypassLobby) -Level Debug;
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
        $review.Id = '710df2b2-b6f8-43f3-9d07-0079497f5c57';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Meetings';
        $review.Title = "Ensure users dialing in can't bypass the lobby";
        $review.Data = $meetingPolicy.AllowPSTNUsersToBypassLobby;
        $review.Review = $reviewFlag;
                                      
        # Print result.
        $review.PrintResult();
                                                     
        # Return object.
        return $review;
    } 
}