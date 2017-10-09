#!/bin/bash
#Primeramente comprobamos los argumentos
if  test $# -lt 2 || ! test -d $1
then
	echo "$0: debe recibir al menos 2 argumentos y cada argumento debe ser un directorio"
	exit 1
fi
#Creamos unas variables las cuales vamos a necesitas
ERROR=0 # SI UNO DE LOS PARAMETROS NO ERA UN DIRECTORIO SE PONE A 1
DEST=$1 # ME COPIO LA VARIABLE EN OTRA PARA AL HACER EL SHIFT NO PERDERLA
COPIARONO=0 #SI ES 0 COPIARA SI ES 1 NO COPIARA COMPROBACION DE DIRECTORIO CON MISMO NOMBRE
#Nos desplazamos y empezamos con los  bucles tras comprobar si da error shift
shift
if test $? -ne 0
then
	echo "$0: se ha producido un error en la instruccion shift"
	exit 2
fi
#Empezamos con el primer bucle que comprueba si es un directorio y si es así va al siguiente for
for var in $@
do
	if test -d $var
	then
#Coge despues los ficheros que esten dentro solamente de ese directorio por eso el maxdepth para no ser recursivo
		for var1 in `find $var -maxdepth 1 -type f`
		do
			NOMBREFICHERO="${var1##*/}"
			NOMBRESINEXTENSION1="${NOMBREFICHERO%.*}"
#Este for es para comprobar que los directorios en destino no coincidan con los nombres de algunos ficheros
			for var2 in `find $DEST -type d`
			do

				NOMBREFICHERO2="${var2##*/}"
				NOMBRESINEXTENSION2="${NOMBREFICHERO2%.*}"

				if [ "$NOMBRESINEXTENSION2" = "$NOMBRESINEXTENSION1" ] 
				then
				COPIARONO=1
				echo "$var2 no se pudo copiar ya que existe un directorio en $DEST con el mismo nombre"
				fi
			done
			if test $COPIARONO -eq 0
			then
				cp -a -u $var1 $DEST
				if test $? -ne 0
				 then
                                                echo "$0: se ha producido un error en la instruccion cp"
                                                exit 2
                                  fi
			fi
			COPIARONO=0
		done
	else
		ERROR=1
	fi
done
#Comprobación si tuviesemos errores
if test $ERROR -eq 1
then
	echo "$0: al menos uno de los argumentos recibidos no era un directorio"
	exit 3
fi
exit 0
