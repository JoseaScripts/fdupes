#!/bin/bash
# /bin/fdupes/EliminarListado.sh
# Creado: 19/10/2017
# Modificado 13/04/2018

# FUNCIONAMIENTO
# Crea un respaldo de todos los archivos listados en un archivo o los elimina
# Como primer parámetro [$1] se envía '-rm' para eliminar los archivos o '-mv' para respaldarlos
# El archivo se determina con un parámetro que se pasa con el comando '$2'

# EJEMPLOS
# EliminarListado.sh -rm fdupes_sort.log
# EliminarListado.sh -mv /media/Multimedia/Listaos/duplicados.fdupes

## VARIABLES ##
RAIZ_='/mnt/Multimedia'
D_respaldos='ABB'
RA_respaldos="$RAIZ_/$D_respaldos"
fecha=$(printf "%(%Y%m%d-%H%M%S)T" -1)

clear

# Introduce la ruta del archivo que contiene el listado de duplicados junto al comando:
listado="$2"

# Compruebo la ruta del listado y que sea legible
if [ -r "$listado" ]; then
 printf "Hola %s.\nEl listado ha sido localizado y es legible\n" $LOGNAME
else
 printf "Listado no localizado o no legible en:\n%s\n" "$listado"
 sleep 1
 exit 0
fi
# ---------------------------------------------------

# Cuento cuantos duplicados quedan ahora y consulto si los elimino
 while read archivo
 do
  if [ ! -z "$archivo" ] && [[ "$archivo" != "# "* ]]; then
  (( k = $k + 1 ))
  printf "\n[%d] %s" "$k" "$archivo"
  fi	
 done < "$listado"

printf "\n\nRespaldar/Eliminar estos %d duplicados [si/no]\n" $k
read eliminar_sn
# ----------------------------------------------------------------

# ELIMINA ARCHIVOS ----------------------------------------------
if [ "$eliminar_sn" = 'si' ]; then
printf "\Moviendo archivos ...\n"
mkdir "$RA_respaldos/$fecha"

sleep 1

while read archivo
do
 if [ ! -z "$archivo" ] && [[ "$archivo" != "# "* ]]; then
  if [ "$1" = '-rm' ]; then
    rm  -v "$archivo"
  elif [ "$1" = '-mv' ]; then
     mv -v --backup=t "$archivo" "$RA_respaldos/$fecha/${archivo##*/}" &> /dev/null
#  else
#     printf "No se ha entendido el comando: Se debe especificar el modo y la lista a examinar\n"
#     exit 0
  fi
  printf "\n[-] "
 else
  printf "\n[+] "
 fi
 printf "%s" "$archivo"
done < "$listado"
fi
printf "\n"
# ------------------------------------------------------------------
