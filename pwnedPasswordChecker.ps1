<#
 Pwned Password Checker Script
 Jonathan Hack

 Description:
 Checks to see if a given password has been part of a data breach and is in the pwned password database
 Script uses the k-knowledge protocol to avoid revealing the entire password hash online
 
 More information can be found at
    https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/
    htts://www.pwnedpasswords.com
 
 Note: Just because a password is not in the database does not guarantee it is a good password

 Credits: 
    Troy Hunt for maintaing the pwned password database (everyone should buy him a beer), and
    Jon Gurgul for the SHA1 hash method
 #>


 <#         ********  How to use this script  **********
  Open a PowerShell window and run the script
  If you can't run the script due to security permissions, you can copy and paste the contents into the PowerShell window
  The script will loop and allow you to enter passwords in.
  You can also call the pwnedPasswordCheck function directly and pass the password as an arugment

#>


Function pwnedPasswordCheck([String] $password){

    $returnValue = 0 # set return value to default to 0
    $StringBuilder = New-Object System.Text.StringBuilder
    [System.Security.Cryptography.HashAlgorithm]::Create("SHA1").ComputeHash([System.Text.Encoding]::UTF8.GetBytes($password))|%{
        [Void]$StringBuilder.Append($_.ToString("x2"))
    }
    $passwordHash = $StringBuilder.ToString().ToUpper()
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    try {
        $siteOut = (Invoke-RestMethod -uri ("https://api.pwnedpasswords.com/range/" + $passwordHash.Substring(0,5)) -ErrorAction stop)
    }
    catch {
        Write-Host "Error checking Pwned database. Possible network issue."
        $password = $passwordHash = $StringBuilder = "" #clear up the clear text password
        throw
    }

    if ($siteOut -match ($passwordHash.Substring(5)+":(.+)")){
        Write-Host ("Password has been compromised, found "+$Matches[1] +" times")
        $returnValue = [int]$Matches[1]
    } else {
        Write-Host ("No hits with pwned passwords")
    }

    $password = $passwordHash = $StringBuilder = "" #clear up the clear text password
    return $returnValue
}
While(1){ #loop around and call the passwordCheck function
    Read-Host –Prompt 'Enter Password to check' | %{pwnedPasswordCheck $_}
    Write-Host ""
}
 

