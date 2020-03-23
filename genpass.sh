#! /bin/bash
EMPTYPARAMETERS=100
EMPTYWORD=101
HELPREQUESTED=102

function usage {
	echo -e "Hacker could generate a custom dictionary."
	echo -e "Usage: ./genpass.sh WORD [-d dictionary] [-o output]"
	echo -e "Parameters:\nWORD: Dictionary's main word.\ndictionary: A list of characters and strings to add as a prefix and sufix of the new dictionary.\nOutput: Optional, if output path is not indicated, application save output in application's root directory.\n"
	exit $HELPREQUESTED
}

function mergeWords {
	while read -r lines; do
		echo -e "\t \e[1;33m [+++] Actual word: *$lines*\e[0m"
		to_out="$1$lines"
		to_out2="$lines$1"
		echo "$to_out" >> $3
		echo "$to_out2" >> $3
	done < "$2"
}

function showErrorAndExit {
	echo "ERROR "
	case $1 in
    $EMPTYPARAMETERS)
      echo "One of the given arguments is empty"
      exit $EMPTYPARAMETERS
      ;;
	$EMPTYWORD)
      echo "Empty word"
      exit $EMPTYWORD
      ;;
    *)
	  break;
      ;;
	esac
}

function emptyArguments {
	if [[ $2 == "Y" ]]; then
		if [[ ! -f $3 ]]; then
			showErrorAndExit $EMPTYPARAMETERS
		fi
	fi

	if [[ $4 == "Y" ]]; then
		if [[ ! -f $5 ]]; then
			showErrorAndExit $EMPTYPARAMETERS
		fi
	fi

	if [[ $1 == "" ]]; then
		showErrorAndExit $EMPTYWORD
	fi
}

if [ $# == 0 ]; then
usage
fi

for arg in "$@"
do
	case $1 in
		-h|--help|--h)
		usage
		;;
		-d|--dictionary)
			dictionary=$1
			dflag="Y"
		shift
		shift
		;;
		-o|--output)
			output=$1
			oflag="Y"
		shift
		shift
		;;
		-w|--word)
			output=$1
		shift
		shift
		;;
		*)
		OTHER_ARGUMENTS+=("$1")
		break
		;;
  esac
done

if 
emptyArguments $word $dflag $dictionary $oflag $output

if [[ $output == "" ]]; then
	touch "passgen"
	$output="passgen"
else
	touch $output
fi

if [[ $dflag == "Y" ]]; then
	mergeWords $word $dictionary $output
fi


echo "Actual word: $word"
echo "$word" >> "passgen"

##REEMPLAZANDO LAS O
number=$(awk -Fo '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/o/s//0/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/o/s//O/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FO '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/O/s//0/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

##REEMPLAZANDO LAS A
number=$(awk -Fa '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/a/s//4/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/a/s//A/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FA '{print NF-1}' <<< "$1")
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/A/s//4/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

##REEMPLAZANDO LAS E
number=$(awk -Fe '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/e/s//3/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/e/s//E/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FE '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/E/s//3/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

##REEMPLAZANDO LAS I
number=$(awk -Fi '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/i/s//1/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/i/s//I/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FI '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/I/s//1/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

##REEMPLAZANDO LAS L
number=$(awk -Fl '{print NF-1}' <<< "$1")

cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/l/s//7/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/l/s//T/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FL '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/L/s//7/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

##REEMPLAZANDO LAS T
number=$(awk -Ft '{print NF-1}' <<< "$1")

cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/t/s//7/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/t/s//T/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FT '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/T/s//7/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

##REEMPLAZANDO LAS S
number=$(awk -Fs '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/s/s//$/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/s/s//S/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done
number=$(awk -FS '{print NF-1}' <<< "$1")
cont=`expr $cont + $number`
i=0
word=$(echo "$1")
while [[ "$i" -lt $number ]];do
word=$(echo "$word" | sed '0,/S/s//$/')
echo "Actual word: $word"
echo "$word" >> "passgen"
let i=i+1
done

#echo "Cont es $cont"
i=0
word=$(echo "$1")
word=$(echo "$word" | sed '0,/s/s//$/g')
word=$(echo "$word" | sed '0,/e/s//3/g')
word=$(echo "$word" | sed '0,/i/s//1/g')
word=$(echo "$word" | sed '0,/o/s//0/g')
word=$(echo "$word" | sed '0,/t/s//7/g')
word=$(echo "$word" | sed '0,/a/s//4/g')
echo "Actual word: $word"
echo "$word" >> "passgen"


word=$(echo "${word}123")
echo "Actual word: $word"
echo "$word" >> "passgen"
word=$(echo $1)
word=$(echo "123${word}")
echo "Actual word: $word"
echo "$word" >> "passgen"

word=$(echo $1)
word=$(echo "$word" | tr [:lower:] [:upper:])
echo "Actual word: $word"
echo "$word" >> "passgen"
word=$(echo "$word" | tr [:upper:] [:lower:])
echo "Actual word: $word"
echo "$word" >> "passgen"
word=$(echo $1)

word=$(echo "$word" | sed 's/\(.\)\(.\)/\L\1\U\2/g')
echo "Actual word: $word"
echo "$word" >> "passgen"
word=$(echo $1)
word=$(echo "$word" | sed -E 's/(.)(.){,1}/\U\1\L\2/g')
echo "Actual word: $word"
echo "$word" >> "passgen"
word=$(echo $1)

i=0
k=0
word=$(echo "$1")
while [[ "$i" -lt "$cont" ]];
do
		read -r line
		word=$(echo "$line")
		word=$(echo "123${word}")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		word=$(echo "$line")
		word=$(echo "${word}123")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		word=$(echo "$line")
		word=$(echo "${word}$")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		word=$(echo "$line")
		word=$(echo "${word}!")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		word=$(echo "$line")
		word=$(echo "${word}!!")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		word=$(echo "$line")
		word=$(echo "_${word}")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		word=$(echo "$line")
		word=$(echo "${word}_")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		let i=i+1
		let k=k+7
done < "passgen"


j=0
year=$(date +'%Y')
echo "Año actual: $year"
while [[ "$j" -lt "$k" ]];
do
		read -r line
		word=$(echo "$line")
		word=$(echo "${word}${year}")
		echo "$word" >> "passgen"
		echo "Actual word: $word"
		let j=j+1
done < "passgen"