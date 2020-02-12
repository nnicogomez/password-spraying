# password-spraying

## ngspraying
                                       _             
 _ __   __ _ ___ _ __  _ __ __ _ _   _(_)_ __   __ _ 
| '_ \ / _` / __| '_ \| '__/ _` | | | | | '_ \ / _` |
| | | | (_| \__ \ |_) | | | (_| | |_| | | | | | (_| |
|_| |_|\__, |___/ .__/|_|  \__,_|\__, |_|_| |_|\__, |
       |___/    |_|              |___/         |___/ 

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
    
    
## passgen.sh

### Description
You could generate a custom dictionary.

### Usage:
`./genpass.sh WORD`
