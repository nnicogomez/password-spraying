# password-spraying

## ngspraying
            
![alt text](https://github.com/nnicogomez/password-spraying/blob/master/images/ngsp.PNG "Logo ngspraying")


### Description
ngspraying is a linux tool that allows test passwords policy of an internal active directory. Usually, ADs have rules that block user account after a number of wrong login attempts. cmeautom controls the time of attempts and the number of attempts, in order to perform the test without blocking the users account.

### Features:
. Application controls login attempts.
. Application dont perform login attempts with users already found.
. Application allows manual configuration of password complexity.
. Application make backup of input-files.

### Installation:
Step 1) We should install the dependencies.
	`./requirements.txt`
Step 2) After that, download ngspraying.sh file and run the application. 
	
### Usage:
	`./ngspraying.sh [Users accounts file] [Password dictionary] [Attempts] [Block time] [Network] [Mask] [Domain]`

### Parameters

#### Users account file:	 
Active Directory users. Format: Only the user account, without the domain (e.g domain\user or user@domain is not correct. Only write the "user" is correct). One user by line.

#### Password dictionary:
Password file. Format: One password by line.

#### Attemps:	
Required attemtps to block the users account. If the account will be block after five (5) wrong attempts (This means, the 6th attemp wont be possible because the account was blocked) in ten (10) minutes, we should enter five (5)."

#### Block time:	
Window time to catch wrong login attempts. Following previously example; if the account will be block after x wrong attempts in 10 minutes, we should enter ten (10).

#### Network:	 
Protocol: IPv4. e.g: 192.168.0.0.

#### Mask:	
Network mask. e.g: 24.

#### Domain: 	
Client domain. e.g: ENTERPRISE.LOCAL\n"

### Typical invoke
    `./ngspraying.sh clientUserFile passwordsDictionary 5 10 192.168.0.0 24 TEST.LOCAL`
    
    
## genpass.sh

![alt text](https://github.com/nnicogomez/password-spraying/blob/master/images/gpss.PNG "Logo genpass.sh")

### Description
This it a very little linux tool which allows to an user to create a password dictionary. Entering a word, the tool will generate possible and simple combinations to test in a password spraying. **This is a complement to a much larger dictionary. The output of this tool DONT is a complete dictionary**

### Synopsys
Normally, client users set a lack of complexity password, using a short password with a main-word that allows the user to remember the password easily. For example, an user that works in FALSECOMPANY could set passwords using this word with the password main-word. The purpose of genpass.sh is create a dictionary in order to cover this point. 

### Usage:
`./genpass.sh WORD`

# Copyright
ngspraying.sh - A linux tool to perform password spraying attacks.

genpass.sh - A linux tool to make dictionaries.

Nicolás Gómez - Copyright © 2020

Those programs are free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Those programs are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
