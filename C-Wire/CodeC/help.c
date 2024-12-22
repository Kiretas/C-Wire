#include <stdio.h>
//Print help option

int main() {
    printf("\tHELP:\n\tUsage: [FILE]... [Options]...\n\tCreate files calculating the consumption of electricity from a data base.\n\tMandatory options:\n\t\t- Complete path of the data file.\n\t\t- Type of station : lv or hva or hvb.\n\t\t- Type of consumer : comp (company) or indiv (individual) or all (no indiv or all are allowed for hvb and hva).\n\tOptional options :\n\t\t- Central number : Analyse the data for only one specific central.\n\t\t- -h : Display the help/manual of utilisation (order in the of this option is not relevant).\n\tThe order of the options is : (path of the file) (type of the stations) (type of consummers) (central number) (-h).\n\tExemple : To see the analysis of the hvb station for the central 4 use (if the folder of the projet is C-Wire in the session of ariles): bash c-wire.sh /home/ariles/C-Wire/input/c-wire_v25.dat hvb comp 4 \n");
    return 0;
}
