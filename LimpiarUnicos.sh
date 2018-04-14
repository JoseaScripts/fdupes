#!/bin/bash
# ~/fdupes/LimpiarUnicos.sh
# Modificaco: 13/04/2018

unicos="/mnt/Multimedia/AAA"
repetidos="/mnt/Multimedia/AAB"
respaldos="/mnt/Multimedia/ABB"

## OTRAS CONFIGURACIONES
listado="fdupes_raw.txt"
listado_noeliminar="fdupes_noeliminar.txt"
listado_sort="fdupes_sort.txt"

fecha=$(printf "%(%Y%m%d-%H%M%S)T" -1)

while read directorio
 do
  originales="$unicos/$directorio"
  duplicados="$repetidos/$directorio"
  printf "\nComprobando directorios ... \n"
  [[ -d $originales ]] && printf "%s encontrado\n" $originales &&  [[ -d $duplicados ]] && printf "%s encontrado\n" $duplicados || printf "\nError, directorio %s no encontrado.\n" $directorio || exit 0

 printf "\nActualizando fechas de modificación de archivos en %s...\n" $duplicados
 find $duplicados/* -print -exec touch {} \;
 printf "\nFechas de modificación actualizadas para %s\n" $duplicados
 fdupes -rfA $originales $duplicados > $listado
 printf "\nListado de duplicados generado: %s" $listado
 sleep 0.5
 printf "\nArchivos duplicados en %s que no serán modificados:\n" $originales
 sort $listado | uniq | grep -v '^$' | grep ^$originales | tee $listado_noeliminar
 sleep 1
 printf "\nOrdenando y filtrando archivos a ser respaldados:\n "
 sleep 0.5
 sort $listado | uniq | grep -v '^$' | grep -v ^$originales > $listado_sort
 printf "\nLlamando a programa de respaldo: RespaldarListado.sh\n"
 wait {$!}
 sleep 0.5



# Compruebo la ruta del listado y que sea legible
if [ -r "$listado_sort" ]; then
 printf "Hola %s.\nEl listado ha sido localizado y es legible\n" $LOGNAME
else
 printf "Listado no localizado o no legible en:\n%s\n" "$listado_sort"
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
 done < "$listado_sort"

printf "\Moviendo archivos ...\n"
mkdir -p "$respaldos/$directorio/$fecha"

sleep 1

while read archivo
do
 if [ ! -z "$archivo" ] && [[ "$archivo" != "# "* ]]; then
  mv -v --backup=t "$archivo" "$respaldos/$directorio/$fecha/${archivo##*/}" &> /dev/null
  printf "\n[-] "
 else
  printf "\n[+] "
 fi
 printf "%s" "$archivo"
done < "$listado_sort"
## fi
printf "\n"
# ------------------------------------------------------------------

 done < subs

find $respaldos/* -type d -print -empty -delete
