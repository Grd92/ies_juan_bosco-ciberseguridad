#!/bin/sh
echo "Hello. Please enter your password."
read password

if [ "$password" == "1234" ]
then
    echo "Welcome!"
else
    echo "Please try again."
fi
