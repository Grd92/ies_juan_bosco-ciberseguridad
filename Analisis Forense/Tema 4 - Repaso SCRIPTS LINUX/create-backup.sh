#!/bin/bash

# save today date
today=`date +%Y-%m-%d--%H-%M-%S`
echo "La fecha actual es: $today"

######>> mysql='ps awx | grep 'mysql' | grep -v|wc -l'

# check one service
echo "Comprobando si el servicio  está activo ..."
if systemctl is-active --quiet networking; then
    echo "El servicio está activo"
else
    echo "El servicio no está activo"
fi