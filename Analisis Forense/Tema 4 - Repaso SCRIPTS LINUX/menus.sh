#!/bin/sh
clear
echo "=== Gastronomía ==="
echo “Dime tu nombre”
read nombre

echo "Hola, $nombre escoge una comida favorite y te sugeriré una
bebida apropiada (maridaje)."

echo "1. Pizza"; 
echo "2. Tostada con mantequilla y mermelada";
echo "3. Tabla de ibéricos y de quesos"

echo "Indica tu elección (1/2/3):"

read elegido
if [ "$elegido" == "1" ] 
then
    echo "Te sugiero una cola o un zumo con gas."
fi

if [ "$elegido" == "2" ] 
then
    echo "Te sugiero tomar leche o zumo de naranja con la tostada."
fi

if [ "$elegido" == "3" ] 
then
    echo "Para saborear manjares de una tabla de ibéricos y
diversos quesos te sugiero un buen vino blanco o una buena
cerveza."
fi