#! /bin/bash

function ayuda {
	echo -e "Hacker could generate a custom dictionary."
	echo -e "Usage:\n./genpass.sh WORD"
}

if [[ $1 == "-help" || $1 == "--help" || $1 == "-h" ]]; then
ayuda
exit
fi

if [ $# != 1 ]; then
echo "Incorrect number of parameters. Retry."
exit
else
echo "Good!"
fi

palabra=$(echo "$1")
echo "Actual word: $palabra"
echo "$palabra" >> passgen

##REEMPLAZANDO LAS O
number=$(awk -Fo '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/o/s//0/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/o/s//O/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FO '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/O/s//0/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

##REEMPLAZANDO LAS A
number=$(awk -Fa '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/a/s//4/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/a/s//A/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FA '{print NF-1}' <<< "$1")
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/A/s//4/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

##REEMPLAZANDO LAS E
number=$(awk -Fe '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/e/s//3/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/e/s//E/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FE '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/E/s//3/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

##REEMPLAZANDO LAS I
number=$(awk -Fi '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/i/s//1/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/i/s//I/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FI '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/I/s//1/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

##REEMPLAZANDO LAS L
number=$(awk -Fl '{print NF-1}' <<< "$1")

cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/l/s//7/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/l/s//T/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FL '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/L/s//7/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

##REEMPLAZANDO LAS T
number=$(awk -Ft '{print NF-1}' <<< "$1")

cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/t/s//7/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/t/s//T/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FT '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/T/s//7/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

##REEMPLAZANDO LAS S
number=$(awk -Fs '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/s/s//$/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/s/s//S/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done
number=$(awk -FS '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
palabra=$(echo "$1")
while [[ "$i" -lt $number ]];do
palabra=$(echo "$palabra" | sed '0,/S/s//$/')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
let i=i+1
done

#echo "Cont es $cont"
i=0
palabra=$(echo "$1")
palabra=$(echo "$palabra" | sed '0,/s/s//$/g')
palabra=$(echo "$palabra" | sed '0,/e/s//3/g')
palabra=$(echo "$palabra" | sed '0,/i/s//1/g')
palabra=$(echo "$palabra" | sed '0,/o/s//0/g')
palabra=$(echo "$palabra" | sed '0,/t/s//7/g')
palabra=$(echo "$palabra" | sed '0,/a/s//4/g')
echo "Actual word: $palabra"
echo "$palabra" >> passgen


palabra=$(echo "${palabra}123")
echo "Actual word: $palabra"
echo "$palabra" >> passgen
palabra=$(echo $1)
palabra=$(echo "123${palabra}")
echo "Actual word: $palabra"
echo "$palabra" >> passgen

palabra=$(echo $1)
palabra=$(echo "$palabra" | tr [:lower:] [:upper:])
echo "Actual word: $palabra"
echo "$palabra" >> passgen
palabra=$(echo "$palabra" | tr [:upper:] [:lower:])
echo "Actual word: $palabra"
echo "$palabra" >> passgen
palabra=$(echo $1)

palabra=$(echo "$palabra" | sed 's/\(.\)\(.\)/\L\1\U\2/g')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
palabra=$(echo $1)
palabra=$(echo "$palabra" | sed -E 's/(.)(.){,1}/\U\1\L\2/g')
echo "Actual word: $palabra"
echo "$palabra" >> passgen
palabra=$(echo $1)

i=0
k=0
palabra=$(echo "$1")
while [[ "$i" -lt "$cont" ]];
do
		read -r line
		palabra=$(echo "$line")
		palabra=$(echo "123${palabra}")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		palabra=$(echo "$line")
		palabra=$(echo "${palabra}123")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		palabra=$(echo "$line")
		palabra=$(echo "${palabra}$")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		palabra=$(echo "$line")
		palabra=$(echo "${palabra}!")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		palabra=$(echo "$line")
		palabra=$(echo "${palabra}!!")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		palabra=$(echo "$line")
		palabra=$(echo "_${palabra}")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		palabra=$(echo "$line")
		palabra=$(echo "${palabra}_")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		let i=i+1
		let k=k+7
done < passgen


j=0
year=$(date +'%Y')
echo "Año actualdsdssdsds: $year"
while [[ "$j" -lt "$k" ]];
do
		read -r line
		palabra=$(echo "$line")
		palabra=$(echo "${palabra}${year}")
		echo "$palabra" >> passgen
		echo "Actual word: $palabra"
		let j=j+1
done < passgen
