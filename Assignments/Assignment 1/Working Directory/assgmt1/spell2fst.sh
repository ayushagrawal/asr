#!/bin/bash
# My first script

# read the options
TEMP=`getopt -o a:b:c: --long odir:,vocab: -n 'evaluate.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -a|--odir)
            case "$2" in
                "") outdir='some default value' ; shift 2 ;;
                *) outdir=$2 ; shift 2 ;;
            esac ;;
        -b|--vocab)
			case "$2" in 
                "") shift 2 ;;
                *) E_fst=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


filename=$1
outdir=$outdir/

while read -r line
do
	name="$line"
	#echo "$name"

	# Reading file and storing the line in an array
	IFS='	' read -a myarray <<< "$name"

	# Making the name of the output file
	outfile="$outdir""${myarray[0]}.fsa.txt"
	#echo "$outfile"
	num=1
	echo "0 1 ${myarray[2]:0:1}" >> "$outfile"
	for (( i=1; i<${#myarray[2]}; i++ )); do
		echo "$num $(( num + 1 )) ${myarray[2]:$i:1}" >> "$outfile"
		num=$(( num + 1 ))
	done
	echo "$num 0" >> "$outfile"
	#fstcompile --acceptor --isymbols=isyms.txt "$outdir""${myarray[0]}.fsa.txt" "$outdir""one/""${myarray[0]}.fsa"
done < "$filename"
