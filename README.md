# password-spraying

element {
  font-size: 75;
}
cmeautom
cmeautom is a tool that allows test password policy of internal active directory. Usually, ADs have rules that block user account after a number of login wrong attemps. cmeautom controls the time of attempts and the number of attempts in order to perform the test without blocking the user accounts.

Features: 
. Attempt control.
. No repetition of users already found.
. Manual configuration of password complexity.
. Make backups of input-files.

Usage:
	./cmeautom.sh [Users account file] [Password dictionary] [Attemps] [Block time] [Network] [Mask] [Domain]

Parameters

Users account file:	 
Active Directory users. Format: Only the user account, without the domain (e.g domain\user is not correct. user is correct). One user by line.

Password dictionary:
Password file. Format: One user by line

Attemps:	
Attemtps to block the account. If the account will be block after five (5) wrong attemps (This means, the 6th attemps wont be possible because the account was blocked) in ten (10) minutes, we enter five (5)

Block time:	
Window time to block the user account. This means, if the account will be block after x wrong attemps in 10 minutes, we entered ten (10).

Network:	 
e.g: 192.168.0.0

Mask:	
e.g: 24

Domain: 	
Client domain. e.g: ENTERPRISE.LOCAL\n"

Tipical invoke
    ./cmeautom.sh clientUserFile passwordsDictionary 5 10 192.168.0.0 24 TEST.LOCAL
