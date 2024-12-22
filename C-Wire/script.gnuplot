
set terminal pngcairo size 800,600 enhanced
eval sprintf("set output '%s'", file_path_output)

set title "Graphique représentant les stations lv les plus et les moins chargées."
set xlabel "Station LV"
set ylabel "Consomation/Capacité (kWh)"

set style data histogram
set style histogram clustered gap 1
set style fill solid border -1
set boxwidth 0.8

set xtics rotate by -45
set grid ytics

set datafile separator ":"



plot file_path using 2:xtic(1) title "Capacité" linecolor rgb "green", \
     '' using 3 title "Consommation" linecolor rgb "red"

