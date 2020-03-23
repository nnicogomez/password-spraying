# password-spraying

## ngspraying
            
![alt text](https://github.com/nnicogomez/password-spraying/blob/master/images/ngsp.PNG "Logo ngspraying")


### Description
ngspraying is a linux tool that allows test passwords policy of an internal active directory. Usually, ADs have rules that block user account after a number of wrong login attempts. cmeautom controls the time of attempts and the number of attempts, in order to perform the test without blocking the users account.

### Key Features:
- Application controls login attempts.
- Application dont perform login attempts with users already found.
- Application allows manual configuration of password complexity.
- Application make backup of input-files.

### Installation:
1. Clone repo.
	`cd /opt && git clone https://github.com/nnicogomez/password-spraying.git`
2. Install dependencies.
	`./requirements.txt`
	
### Usage:
	` ./ngspraying.sh -uf Users_accounts_file -pd Password_dictionary -a attempts_number -bt Block_time -n Network -m Mask -d Domain [-pc] `
### Parameters

#### Users account file:	 
Active Directory users. Format: Only user accounts, it should not be included the domain (e.g domain\user or user@domain isn't correct. Only "user" is correct). One user by line.
#### Password dictionary:
Password file. Format: One password by line.
#### Attempts:	
Required attempts to block the users account. In case that DA lock accounts after five (5) wrong attempts*, we should enter five (5).
*This means, the 6th attempt wont be possible because the account will have been blocked after the 5th attempt, in ten (10) minutes*
#### Block time:	
Window time to catch wrong login attempts. Following previously example; if the account will be block after x wrong attempts in 10 minutes, we should enter ten (10).
#### Network:	 
Protocol: IPv4. e.g: 192.168.0.0.
#### Mask:	
Network mask. e.g: 24.
#### Domain: 	
Client domain. e.g: ENTERPRISE.LOCAL\n"
#### Password Complexity
Boolean parameter that indicates if the target domain controller has "Password complexity" enabled. When this flag is used the script works with the password complexity associated to pc/NGCONFIG.cfg. By default, the non-complexity is 6 characters without required numbers, capital letters, special characters.

### Typical invoke
    `./ngspraying.sh -uf clientUserFile -pd passwordsDictionary -a 5 -bt 10 -n 192.168.0.0 -m 24 -d TEST.LOCAL`
### To do
- Detailed HTML Output.
- Set password policy parameters using the WS version.
- Expand error codes
- Add crackmapexec call using a file
- Add docker use option.

### WS Password Complexity rules
If Password complexity is enabled on domain controller, the following will be the password requirements:

Windows Server 2016
Passwords must be at least six characters in length.
English uppercase characters (A through Z).
English lowercase characters (a through z).
Base 10 digits (0 through 9).
Non-alphabetic characters (for example, !, $, #, %)

Windows Server 2012 and 2012 R2
6 caracteres
Passwords must be at least six characters in length.
English uppercase characters (A through Z).
English lowercase characters (a through z).
Base 10 digits (0 through 9).
Non-alphabetic characters (for example, !, $, #, %)

Windows Server 2003
https://www.tacktech.com/display.cfm?ttid=354
Has at least 6 characters
Does not contain "Administrator" or "Admin"
Contains characters from three of the following categories:
Uppercase letters (A, B, C, and so on)
Lowercase letters (a, b, c, and so on)
Numbers (0, 1, 2, and so on)
Non-alphanumeric characters (#, &, ~, and so on)

Windows Server 2008 and 2008 R2
https://thebackroomtech.com/2008/03/10/windows-server-2008-password-complexity-requirements/
Passwords cannot contain the user’s account name or parts of the user’s full name that exceed two consecutive characters.
Passwords must be at least six characters in length.
Passwords must contain characters from three of the following four categories:
English uppercase characters (A through Z).
English lowercase characters (a through z).
Base 10 digits (0 through 9).
Non-alphabetic characters (for example, !, $, #, %)
    
## genpass.sh

![alt text](https://github.com/nnicogomez/password-spraying/blob/master/images/gpss.PNG "Logo genpass.sh")

### Description
This it a very little linux tool which allows to an user to create a password dictionary. Entering a word, the tool will generate possible and simple combinations to test in a password spraying. **This is a complement to a much larger dictionary. The output of this tool DONT is a complete dictionary**

### Synopsys
Normally, client users set a lack of complexity password, using a short password with a main-word that allows the user to remember the password easily. For example, an user that works in FALSECOMPANY could set passwords using this word with the password main-word. The purpose of genpass.sh is create a dictionary in order to cover this point. 

### Usage:
`./genpass.sh WORD [-d dictionary] [-o output]`

### Parameters

#### WORD:	
Dictionary's main word (e.g. Company name)
#### Dictionary
A list of words to merge with the aforementioned main word. Optional parameter.
#### Output
Output path. If it is not indicated, application save the output in application's root directory.

# Copyright
ngspraying.sh - A linux tool to perform password spraying attacks.

genpass.sh - A linux tool to make dictionaries.

Nicolás Gómez - Copyright © 2020

Those programs are free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Those programs are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
