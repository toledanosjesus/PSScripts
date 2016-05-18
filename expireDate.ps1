####################################################
##	SHOW USER PASSWORD EXPIRY DATE
####################################################

##############################	REQUIREMENTS

# Active Directory module
import-module activeDirectory

# Load the Assembly
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null


##############################	GLOBAL VARIABLES

$CHECK = "FALSE"     

##############################	PROGRAM

while ($CHECK -eq "FALSE") {

    # Ask for the user to check
    $USER = Read-Host 'Who is the user?'

    # Get the user properties
    $INFOUSER = Get-ADUser -filter {SamAccountName -eq $USER} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

    # CHECK if the user exists
    if ($INFOUSER) {

        # Change the global variable to break the while loop
        $CHECK = "TRUE"
     
        # Select the name
        $NAME = ([string]$INFOUSER).Substring(14,22)

        # Select the expiry date
        $DATE = ([string]$INFOUSER).Substring(49,19)

        # Show the expire date
        [System.Windows.Forms.MessageBox]::Show("The expire date for $NAME is $DATE" , "Status") 

    } else { 
        
        # Show the error window
        $OUTPUT= [System.Windows.Forms.MessageBox]::Show("The user $USER does not exist. Do you want try again?" , "Error" , 5)

        # Break the while loop
        if ($OUTPUT -eq "Cancel" ) { break }
        
    }

}
