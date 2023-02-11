#!/bin/bash

# save today date
TODAY=`date +%Y-%m-%d--%H-%M-%S`
echo "La fecha actual es: $TODAY \n"

# check one service
echo "Comprobando si el servicio  está activo ... \n"
if systemctl is-active --quiet networking; then
    echo "\nEl servicio está activo \n"
else
    echo "\nEl servicio no está activo \n"
fi
    # other way to check: mysql='ps awx | grep 'mysql' | grep -v|wc -l'

# ask the user an option and act on the choice
echo "Seleccione una opción: 
1 ) dd : Realizar copia completa copia completa de dispositivo con dd
2 ) tar : Realizar copia de seguridad con tar
3 ) cp -a : Realizar una copia de directorios/archivos con cp -a"

read -p "Seleccione una de las opciones [1,2,3] : " OPTION

case $OPTION in
1)
    echo "Seleccionada la opccion 1"
    read -p "Indica la ruta del dispositivo: " DEVICE
    read -p "Indica la ruta de destino: " TO_FOLDER
    
    sudo dd if=$DEVICE of=$TO_FOLDER
    ;;
2)
    echo "Seleccionada la opccion 2"
    read -p "Indica la ruta de origen: " FROM_FOLDER
    read -p "Indica la ruta de destino: " TO_FOLDER
    
    sudo tar -cvpzf $TO_FOLDER $FROM_FOLDER
    ;;
3)
    echo "Seleccionada la opccion 3"
    read -p "Indica la ruta de origen: " FROM_FOLDER
    read -p "Indica la ruta de destino: " TO_FOLDER
    
    sudo cp -a $FROM_FOLDER $TO_FOLDER
    echo "Se ha realizado la copia de los directorios/archivos de $FROM_FOLDER en $TO_FOLDER"
    ;;
*)
    echo "La opción seleccionada no es valida"
esac

# Inform the user of the occupied space
USE_STORAGE=$(du -sh $TO_FOLDER)
echo "La opcion $OPTION ha ocupado el siguiente espacio: $USE_STORAGE"