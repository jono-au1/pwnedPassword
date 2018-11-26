# pwnedPassword
Script for checking Pwned Password Database
pwnedPasswordChecker is a PowerShell script for checking to see if your passwords have been pwned.

According to haveibeenpwned.com, the Pwned Password database contains more than half a billion passwords which have previously been exposed in data breaches. For more information on the database and where it came from visit https://haveibeenpwned.com and https://www.troyhunt.com/introducing-306-million-freely-downloadable-pwned-passwords/npwned.com

The Pwned passwords are stored in the database as a SHA-1 hash of the original plaintext password along with the number of times that password has been seen.

This script uses the k-anonymizer model feature of the pwned passwords of the API to avoid sharing the source of the password. This works by sending the first 5 characters of the SHA-1 hash to the online database, the database then sends all results with the corresponding hash prefix. The scipt then matches the results with the rest of the hash. This approach ensures the clear text password and the full SHA-1 hash of the password never leave the host.

To use this script:
  1. Simply run the script in a Powershell window (you can copy and paste if your host doesn't allow running scripts).
  2. Enter a password when prompted
  
Once the script is loaded, you can check passwords from the command line
      PS > pwnedPasswordCheck mypassword
 Note: if you do use this consider that windows logs Powershell history and your passwords will likely be saved in the history

