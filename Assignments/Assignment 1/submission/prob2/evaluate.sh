#!/bin/bash

# read the options
TEMP=`getopt -o a:b:c: --long Mdir:,E:,T:,G: -n 'evaluate.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -a|--Mdir)
            case "$2" in
                "") M_dir='some default value' ; shift 2 ;;
                *) M_dir=$2 ; shift 2 ;;
            esac ;;
        -b|--E)
			case "$2" in 
                "") shift 2 ;;
                *) E_fst=$2 ; shift 2 ;;
            esac ;;
        -c|--T)
            case "$2" in
                "") shift 2 ;;
                *) T_fst=$2 ; shift 2 ;;
            esac ;;
		-c|--G)
            case "$2" in
                "") shift 2 ;;
                *) G_fst=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

check_file=$1

# do something with the variables -- in this case the lamest possible one :-)
#echo "M_dir = $M_dir"
#echo "E_fst = $E_fst"
#echo "T_fst = $T_fst"
#echo "G_fst = $G_fst"
#echo "check = $check_file"

######################################
filenames=()
for file in "$M_dir"/*
do
	filenames+=("$file")
done


filenames=( $(
    for el in "${filenames[@]}"
    do
        echo "$el"
    done | sort -V ) )

arraylength=${#filenames[@]}

#echo "$arraylength"


# Inverting T
T_inv_fst=Tinv.fst
fstinvert $T_fst $T_inv_fst

#Composing the FST
comp_fst=comp.fst
E_fst_sort=E_sort.fst
T_inv_fst_sort=Tinv_sort.fst
G_fst_sort=G_sort.fst
fstarcsort --sort_type=olabel $E_fst $E_fst_sort
#fstarcsort --sort_type=ilabel $T_inv_fst $T_inv_fst_sort
#fstarcsort --sort_type=olabel $G_fst $G_fst_sort
fstcompose $E_fst_sort $T_inv_fst $comp_fst	# UC
fstcompose $G_fst $comp_fst $comp_fst			# UC

echo "Done"
# EVALUATING THE FSAs


# Compiling the {}.fsa.txt to {}.fsa
mkdir m_fsa	# UC
#mkdir Test
mkdir result	# UC
mkdir output	# UC
m_fsa=m_fsa/ 
for (( i=0; i<${arraylength}; i++ ));
do
	fstcompile --acceptor --isymbols=isyms.txt ${filenames[i]} $m_fsa$i".fsa"	# UC

	# For debugging (Visualization)
	#fstdraw --acceptor --portrait --isymbols=isyms.txt --osymbols=osyms.txt $m_fsa$i".fsa" Test/$i".dot"
	#dot -Tpdf Test/$i".dot" >Test/draw$i.pdf

	
	fstcompose $m_fsa$i.fsa $comp_fst result/result$i.fst		# UC
	#fstdraw --portrait --isymbols=isyms.txt --osymbols=osyms.txt result/result$i.fst result/result$i.dot
	#dot -Tpdf result/result$i.dot >result/result$i.pdf

	#fstshortestpath --unique Test/test$i.fst Test/test$i.fst
	fstshortestpath result/result$i.fst output/out$i.fst	# UC
	#fstdraw --portrait --isymbols=isyms.txt --osymbols=osyms.txt result/result$i.fst result/result$i.dot
	#dot -Tpdf result/result$i.dot >result/result$i.pdf
done

echo "FST printing to FSA (outputs)"
word1=() 
for (( i=0; i<${arraylength}; i++ ));
do
	fstproject --project_output=true output/out"$i".fst output/out"$i".fsa		#UC
	fstprint --osymbols=osyms.txt output/out"$i".fsa output/out"$i".txt		#UC
	line=$(head -n 1 output/out"$i".txt)
	line=( $line )
	word1+=("${line[3]}")
	#echo ${filenames[i]}
done

word2=()
while IFS='' read -r line || [[ -n "$line" ]]; do
	line=( $line )
	word2+=("${line[1]}")
done < "$check_file"

#echo "${word1[1]} ${word2[1]}"

num=0
for (( i=0; i<${arraylength}; i++ ));
do
	if [[ ${word1[i]} == ${word2[i]} ]] ; then
		num=$((num + 1))
	fi
done
acc=$((100*num / arraylength))
echo "Accuracy is of: "$acc | sed 's/..$/.&/' >> acc1.txt
