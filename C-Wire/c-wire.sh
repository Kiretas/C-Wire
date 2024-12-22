#!/bin/bash

#Definition of the arguments
file="$1"
userarg1="$2"
userarg2="$3"
centralid="$4"
help="$5"
time=0

help() {
    echo "      HELP:
                Usage: [FILE]... [Options]...
                Create files calculating the consumption of electricity from a data base.
                Mandatory options:
                    - Complete path of the data file.
                    - Type of station : lv or hva or hvb.
                    - Type of consumer : comp (company) or indiv (individual) or all (no indiv or all are allowed for hvb and hva).
                Optional options :
                    - Central number : Analyse the data for only one specific central.
                    - -h : Display the help/manual of utilisation (order in the of this option is not relevant).
                The order of the options is : (path of the file) (type of the stations) (type of consummers) (central number) (-h).
                Exemple : To see the analysis of the hvb station for the central 4 use (if the folder of the projet is C-Wire in the session of ariles): 
                    - bash c-wire.sh /home/ariles/C-Wire/input/c-wire_v25.dat hvb comp 4"
}

#Search for help option
for i in "$@"; do
    if [ "$i" = "-h" ]; then
        help
        exit 7
    fi
done

#Verification of files and folders existences
if [ -d "CodeC" ]; then
    echo "Le dossier CodeC est présent."
else                                                                        #If verification fails exit and print help option
    echo "Le dossier CodeC devant contenir les programmes C n'existe pas."
    help
    exit 1
fi

if [ -d "graphs" ]; then
    echo "Le dossier graphs est présent."
else                                                                        #If verification fails exit and print help option
    echo "Le dossier graphs devant contenir les graphiques générés n'existe pas."
    help
    exit 2
fi

if [ -d "tests" ]; then
    echo "Le dossier tests est présent."
else                                                                        #If verification fails exit and print help option
    echo "Le dossier tests devant contenir les résultats n'existe pas."
    help
    exit 3
fi

echo "Tous les dossiers nécessaires sont présents."


filesC=("CodeC/code.c" "CodeC/consumer.h" "CodeC/rotation.h" "CodeC/insertion.h" "CodeC/tools.h" "CodeC/consumer.c" "CodeC/rotation.c" "CodeC/insertion.c" "CodeC/tools.c"
       "CodeC/sort.c" "CodeC/consumer_sort.h" "CodeC/rotation_sort.h" "CodeC/insertion_sort.h" "CodeC/tools_sort.h" "CodeC/consumer_sort.c" "CodeC/rotation_sort.c" "CodeC/insertion_sort.c" "CodeC/tools_sort.c")
for fileC in "${filesC[@]}"; do
    if [ -f "$fileC" ]; then
        echo "Le fichier $fileC existe."
    else                                                                    #If verification fails exit and print help option
        echo "Le fichier $fileC n'existe pas. Entrez le chemin du fichier .dat complet."
        help
        exit 4
    fi
done

if [ -f "$file" ]; then
    echo "Le fichier "$file" existe."
else                                                                        #If verification fails exit and print help option
    echo "Le fichier "$file" n'existe pas. Entrez le chemin du fichier .dat complet."
    help
    exit 5
fi

if [ -f "script.gnuplot" ]; then
    echo "Le fichier script.gnuplot existe."
else                                                                        #If verification fails exit and print help option
    echo "Le fichier script.gnuplot n'existe pas. Entrez le chemin du fichier .dat complet."
    help
    exit 6
fi

echo "Tous les fichiers nécessaires sont présents."


#Compilation of C programs
make -C CodeC
#Remove .o files
rm $PWD/CodeC/*.o



if [ -n "$centralid" ]; then                        #Search for central option
    if [[ ! "$centralid" =~ ^[0-9]+$ ]]; then       #Verification of centralid compatibility
    echo "Entrez un numéro de centrale correct."
    help                                 #Print help option
    elif [ "$userarg1" = "hvb" ]; then              #Verification of station name compatibility
        if [ "$userarg2" = "comp" ]; then           #Verification of consumer arg compatibility
            echo "Station HV-B:Capacité:Consommation (entreprises)" > $PWD/tests/hvb_comp_"$centralid".csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | cut -d ';' -f1,2,3,5,7,8 | grep -E "^$centralid;\b[0-9]*\b;-;" | cut -d ';' -f2,5,6 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/hvb_comp_"$centralid".csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/hvb_comp_"$centralid".csv)"; tail -n +2 $PWD/tests/hvb_comp_"$centralid".csv | sort -t ':' -k3,3nr) > $PWD/tests/hvb_comp_"$centralid".tmp && mv $PWD/tests/hvb_comp_"$centralid".tmp $PWD/tests/hvb_comp_"$centralid".csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "all" ]; then          #Verification of consumer arg compatibility
            echo "L'utilisation de all n'est pas permise avec hvb."
            help                         #Print help option
        elif [ "$userarg2" = "indiv" ]; then        #Verification of consumer arg compatibility
            echo "L'utilisation de indiv n'est pas permise avec hvb."
            help                         #Print help option
        else                                        #Verification of consumer arg compatibility
            echo "Le deuxième paramètre est incorrect."
            help                         #Print help option
        fi
    elif [ "$userarg1" = "hva" ]; then              #Verification of station name compatibility
        if [ "$userarg2" = "comp" ]; then           #Verification of consumer arg compatibility
            echo "Station HV-A:Capacité:Consommation (entreprises)" > $PWD/tests/hva_comp_"$centralid".csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | cut -d ';' -f1,3,4,5,7,8 | grep -E "^$centralid;\b[0-9]*\b;-;" | cut -d ';' -f2,5,6 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/hva_comp_"$centralid".csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/hva_comp_"$centralid".csv)"; tail -n +2 $PWD/tests/hva_comp_"$centralid".csv | sort -t ':' -k3,3nr) > $PWD/tests/hva_comp_"$centralid".tmp && mv $PWD/tests/hva_comp_"$centralid".tmp $PWD/tests/hva_comp_"$centralid".csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "all" ]; then          #Verification of consumer arg compatibility
            echo "L'utilisation de all n'est pas permise avec hva."
            help                         #Print help option
        elif [ "$userarg2" = "indiv" ]; then        #Verification of consumer arg compatibility
            echo "L'utilisation de indiv n'est pas permise avec hva."
            help                         #Print help option
        else                                        #Verification of consumer arg compatibility
            echo "Le deuxième paramètre est incorrect."
            help                         #Print help option
        fi
    elif [ "$userarg1" = "lv" ]; then               #Verification of station name compatibility
        if [ "$userarg2" = "comp" ]; then           #Verification of consumer arg compatibility
            echo "Station LV:Capacité:Consommation (entreprises)" > $PWD/tests/lv_comp_"$centralid".csv         #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | grep -E "^$centralid;[^;]*;[^;]*;\b[0-9]*\b;[^;]*;-;" | cut -d ';' -f4,7,8 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/lv_comp_"$centralid".csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/lv_comp_"$centralid".csv)"; tail -n +2 $PWD/tests/lv_comp_"$centralid".csv | sort -t ':' -k3,3nr) > $PWD/tests/lv_comp_"$centralid".tmp && mv $PWD/tests/lv_comp_"$centralid".tmp $PWD/tests/lv_comp_"$centralid".csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "indiv" ]; then        #Verification of consumer arg compatibility
            echo "Station LV:Capacité:Consommation (particuliers)" > $PWD/tests/lv_indiv_"$centralid".csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | grep -E "^$centralid;[^;]*;[^;]*;\b[0-9]*\b;-;[^;]*;" | cut -d ';' -f4,7,8 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/lv_indiv_"$centralid".csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/lv_indiv_"$centralid".csv)"; tail -n +2 $PWD/tests/lv_indiv_"$centralid".csv | sort -t ':' -k3,3nr) > $PWD/tests/lv_indiv_"$centralid".tmp && mv $PWD/tests/lv_indiv_"$centralid".tmp $PWD/tests/lv_indiv_"$centralid".csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "all" ]; then          #Verification of consumer arg compatibility
            echo "Station LV:Capacité:Consommation (tous)" > $PWD/tests/lv_all_"$centralid".csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | grep -E "^$centralid;[^;]*;[^;]*;\b[0-9]*\b;[^;]*;[^;]*;" | cut -d ';' -f4,7,8 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/lv_all_"$centralid".csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/lv_all_"$centralid".csv)"; tail -n +2 $PWD/tests/lv_all_"$centralid".csv | sort -t ':' -k3,3nr) > $PWD/tests/lv_all_"$centralid".tmp && mv $PWD/tests/lv_all_"$centralid".tmp $PWD/tests/lv_all_"$centralid".csv #Sort the output file
            tail -n +2 $PWD/tests/lv_all_"$centralid".csv | $PWD/CodeC/sort > $PWD/tests/lv_all_tmp_"$centralid".csv        #Send to sort.c to be sorted by (capacity-load) and stored in temporary file
            echo "Min and Max 'capacity-load' extreme nodes" > $PWD/tests/lv_all_minmax_"$centralid".csv                    #Creation of minmax output file
            echo "Station LV:Capacité:Consommation (tous)" >> $PWD/tests/lv_all_minmax_"$centralid".csv                      #Add a header in minmax output file
            tail -n +3 $PWD/tests/lv_all_tmp_"$centralid".csv | head -10 >> $PWD/tests/lv_all_minmax_"$centralid".csv       #Keep only first 10 biggest overcharged stations to minmax output file
            tail -n +2 $PWD/tests/lv_all_tmp_"$centralid".csv | tail -10 >> $PWD/tests/lv_all_minmax_"$centralid".csv       #Keep only last 10 lowest overcharged stations to minmax output file
            rm $PWD/tests/lv_all_tmp_"$centralid".csv                                                                       #Remove temporary file
            gnuplot -e "file_path=system('echo $PWD') . '/tests/lv_all_minmax_"$centralid".csv'; file_path_output=system('echo $PWD') . '/graphs/graph_lv_all_minmax_"$centralid".png'" script.gnuplot      #Creation of the graph
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        else                                        #Verification of consumer arg compatibility
            echo "Le deuxième paramètre est incorrect."
            help                         #Print help option
        fi
    else                                            #Verification of station name compatibility
        echo "Le premier paramètre est incorrect."
        help                             #Print help option
    fi
else
    if [ "$userarg1" = "hvb" ]; then                #Verification of station name compatibility
        if [ "$userarg2" = "comp" ]; then           #Verification of consumer arg compatibility
            echo "Station HV-B:Capacité:Consommation (entreprises)" > $PWD/tests/hvb_comp.csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | cut -d ';' -f1,2,3,5,7,8 | grep -E "^[0-9]*;\b[0-9]*\b;-;" | cut -d ';' -f2,5,6 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/hvb_comp.csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/hvb_comp.csv)"; tail -n +2 $PWD/tests/hvb_comp.csv | sort -t ':' -k3,3nr) > $PWD/tests/hvb_comp.tmp && mv $PWD/tests/hvb_comp.tmp $PWD/tests/hvb_comp.csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "all" ]; then          #Verification of consumer arg compatibility
            echo "L'utilisation de all n'est pas permise avec hvb."
            help                         #Print help option
        elif [ "$userarg2" = "indiv" ]; then        #Verification of consumer arg compatibility
            echo "L'utilisation de indiv n'est pas permise avec hvb."
            help                         #Print help option
        else                                        #Verification of consumer arg compatibility
            echo "Le deuxième paramètre est incorrect."
            help                         #Print help option
        fi
    elif [ "$userarg1" = "hva" ]; then              #Verification of station name compatibility
        if [ "$userarg2" = "comp" ]; then           #Verification of consumer arg compatibility
            echo "Station HV-A:Capacité:Consommation (entreprises)" > $PWD/tests/hva_comp.csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | cut -d ';' -f1,3,4,5,7,8 | grep -E "^[0-9]*;\b[0-9]*\b;-;" | cut -d ';' -f2,5,6 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/hva_comp.csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/hva_comp.csv)"; tail -n +2 $PWD/tests/hva_comp.csv | sort -t ':' -k3,3nr) > $PWD/tests/hva_comp.tmp && mv $PWD/tests/hva_comp.tmp $PWD/tests/hva_comp.csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "all" ]; then          #Verification of consumer arg compatibility
            echo "L'utilisation de all n'est pas permise avec hva."
            help                         #Print help option
        elif [ "$userarg2" = "indiv" ]; then        #Verification of consumer arg compatibility
            echo "L'utilisation de indiv n'est pas permise avec hva."
            help                         #Print help option
        else                                        #Verification of consumer arg compatibility
            echo "Le deuxième paramètre est incorrect."
            help                         #Print help option
        fi
    elif [ "$userarg1" = "lv" ]; then               #Verification of station name compatibility
        if [ "$userarg2" = "comp" ]; then           #Verification of consumer arg compatibility
            echo "Station LV:Capacité:Consommation (entreprises)" > $PWD/tests/lv_comp.csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | grep -E "^[0-9]*;[^;]*;[^;]*;\b[0-9]*\b;[^;]*;-;" | cut -d ';' -f4,7,8 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/lv_comp.csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/lv_comp.csv)"; tail -n +2 $PWD/tests/lv_comp.csv | sort -t ':' -k3,3nr) > $PWD/tests/lv_comp.tmp && mv $PWD/tests/lv_comp.tmp $PWD/tests/lv_comp.csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "indiv" ]; then        #Verification of consumer arg compatibility
            echo "Station LV:Capacité:Consommation (particuliers)" > $PWD/tests/lv_indiv.csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | grep -E "^[0-9]*;[^;]*;[^;]*;\b[0-9]*\b;-;[^;]*;" | cut -d ';' -f4,7,8 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/lv_indiv.csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/lv_indiv.csv)"; tail -n +2 $PWD/tests/lv_indiv.csv | sort -t ':' -k3,3nr) > $PWD/tests/lv_indiv.tmp && mv $PWD/tests/lv_indiv.tmp $PWD/tests/lv_indiv.csv #Sort the output file
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        elif [ "$userarg2" = "all" ]; then          #Verification of consumer arg compatibility
            echo "Station LV:Capacité:Consommation (tous)" > $PWD/tests/lv_all.csv      #Creation of the output file
            start=$(date +%s)                       #Start of the processing timer
            cat "$file" | grep -E "^[0-9]*;[^;]*;[^;]*;\b[0-9]*\b;[^;]*;[^;]*;" | cut -d ';' -f4,7,8 | tr - 0 | $PWD/CodeC/code >> $PWD/tests/lv_all.csv        #Filtering the data file / Send it to C program / copy output to output file
            (echo "$(head -n 1 $PWD/tests/lv_all.csv)"; tail -n +2 $PWD/tests/lv_all.csv | sort -t ':' -k3,3nr) > $PWD/tests/lv_all.tmp && mv $PWD/tests/lv_all.tmp $PWD/tests/lv_all.csv #Sort the output file
            tail -n +2 $PWD/tests/lv_all.csv | $PWD/CodeC/sort > $PWD/tests/lv_all_tmp.csv      #Send to sort.c to be sorted by (capacity-load) and stored in temporary file
            echo "Min and Max 'capacity-load' extreme nodes" > $PWD/tests/lv_all_minmax.csv     #Creation of minmax output file
            echo "Station LV:Capacité:Consommation (tous)" >> $PWD/tests/lv_all_minmax.csv      #Add a header in minmax output file
            tail -n +3 $PWD/tests/lv_all_tmp.csv | head -10 >> $PWD/tests/lv_all_minmax.csv     #Keep only first 10 biggest overcharged stations to minmax output file
            tail -n +2 $PWD/tests/lv_all_tmp.csv | tail -10 >> $PWD/tests/lv_all_minmax.csv     #Keep only last 10 lowest overcharged stations to minmax output file
            rm $PWD/tests/lv_all_tmp.csv                                                        #Remove temporary file
            gnuplot -e "file_path=system('echo $PWD') . '/tests/lv_all_minmax.csv'; file_path_output=system('echo $PWD') . '/graphs/graph_lv_all_minmax.png'" script.gnuplot       #Creation of the graph
            end=$(date +%s)                         #End of the processing timer
            time=$((time + end - start ))           #Calcul of total processing time
        else                                        #Verification of consumer arg compatibility
            echo "Le deuxième paramètre est incorrect."
            help                         #Print help option
        fi
    else                                            #Verification of station name compatibility
        echo "Le premier paramètre est incorrect."
        help                             #Print help option
    fi
fi

echo "Temps d'execution : $time secondes."          #Print time of processing
