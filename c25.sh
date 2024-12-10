TEMP_FILE="processed_data.csv"

path="$1"
userarg1="$2"
userarg2="$3"

# Création ou réinitialisation du fichier temporaire

> "$TEMP_FILE"

if [ -d "$path" ]; then
    cd "$path"
else
    echo "Erreur : Le répertoire '$path' n'existe pas."
    exit 1
fi

if [ "$userarg1" = "hvb" ]; then
    if [ "$userarg2" = "comp" ]; then
        cat c-wire_v25.dat | cut -d ';' -f1,2,5,7,8 | grep -E "^[0-9]*;\b[0-9]*\b;[0-9]*;-;[0-9]*" > "$TEMP_FILE"
    elif [ "$userarg2" = "all" ]; then
        echo "L'utilisation de all n'est pas permise avec hvb."
    elif [ "$userarg2" = "indiv" ]; then
        echo "L'utilisation de indiv n'est pas permise avec hvb."
    else
        echo "Le deuxieme parametre est incorrect."
    fi

elif [ "$userarg1" = "hva" ]; then
    if [ "$userarg2" = "comp" ]; then
        cat c-wire_v25.dat | cut -d ';' -f1,3,5,7,8 | grep -E "^[0-9]*;\b[0-9]*\b;[0-9]*;-;[0-9]*" > "$TEMP_FILE"
    elif [ "$userarg2" = "all" ]; then
        echo "L'utilisation de all n'est pas permise avec hva"
    elif [ "$userarg2" = "indiv" ]; then
        echo "L'utilisation de indiv n'est pas permise avec hva"
    else
        echo "Le deuxieme parametre est incorrect."
    fi

elif [ "$userarg1" = "lv" ]; then
    if [ "$userarg2" = "comp" ]; then
        cat c-wire_v25.dat | cut -d ';' -f1,4,5,7,8 | grep -E "^[0-9]*;\b[0-9]*\b;[0-9]*;-;[0-9]*" > "$TEMP_FILE"
    elif [ "$userarg2" = "all" ]; then
        cat c-wire_v25.dat | cut -d ';' -f1,4,5,6,7,8 | grep -E "^[0-9]*;\b[0-9]*\b;[0-9]*;[0-9]*;-;[0-9]*" > "$TEMP_FILE"
    elif [ "$userarg2" = "indiv" ]; then
        cat c-wire_v25.dat | cut -d ';' -f1,2,5,6,8 | grep -E "^[0-9]*;\b[0-9]*\b;[0-9]*;-;[0-9]*" > "$TEMP_FILE"
    else
        echo "Le deuxieme parametre est incorrect."
    fi
else
    echo "Le premier paramètre est incorrect."
fi

awk -F ';' '
{
    if ($2 != "-") {
        print $2, $5  # HV-B station and consumption
    } else if ($3 != "-") {
        print $3, $5  # HV-A station and consumption
    } else if ($4 != "-") {
        print $4, $5  # LV station and consumption
    }
}' processed_data.csv > filtered_data.txt


#Lancer le traitement du code C




rm "$TEMP_FILE"
