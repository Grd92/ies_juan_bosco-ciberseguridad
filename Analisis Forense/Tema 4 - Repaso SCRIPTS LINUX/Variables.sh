#!/bin/sh
variable="Quiero comer pizza!"
echo ${variable}

ini=0
fin=6
echo ${variable:ini:fin}

variable2="Voy a programar!"
fin2=${#variable2}
echo ${variable2:6:fin2}

echo {z..a}
echo {1..10}

echo "Otros valores de inicio fin"
echo ${variable:7:5}

echo "Abecedario"
echo {a..z}

