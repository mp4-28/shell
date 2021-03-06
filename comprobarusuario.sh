#!/bin/bash

# Comando para comprobar el ingreso de usuario
# Algoritmo de:
# http://www.yourownlinux.com/2015/08/how-to-check-if-username-and-password-are-valid-using-bash-script.html

USUARIO=$1;
CONTRA=$2;

id -u $USUARIO > /dev/null; 	# Comprovar existencia del usuario
if [ $? -ne 0 ]; then	# Si $USUARIO no estA en la lista de usuarios
        echo "Nombre de usuario no valido";
        exit 1;		# Sale regresando fallo
else
		## Si el usuario ingresado es valido ##
        export CONTRA;
        CONTRAVDRA=`grep -w "$USUARIO" /etc/shadow | cut -d: -f2`;
        export ALGOR=`echo $CONTRAVDRA | cut -d'$' -f2`;
        export SALT=`echo $CONTRAVDRA | cut -d'$' -f3`;
        GENCONTRA=$(perl -le 'print crypt("$ENV{CONTRA}","\$$ENV{ALGOR}\$$ENV{SALT}\$")');
        echo "";
	if [ "$GENCONTRA" == "$CONTRAVDRA" ]; then
                unset CONTRA;
		echo -e "Nombre de usuario y contrase\xc3\xb1a validos";
                exit 0;
        else
		unset CONTRA;
                echo -e "Contrase\xc3\xb1a invalida";
                exit 1;
        fi
fi

