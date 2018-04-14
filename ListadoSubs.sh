#!/bin/bash
# ~/bin/fdupes/ListadoSubs.sh
# Modificado: 13/04/2018

# USO
# Crea un listado de sub-directorios de $unicos - sub_sort
# Luego ejecuta Listadofdupes.sh sobre esos directorios contra los mismos en $repetidos

# PENDIENTE
# Actualizar la fecha de modificación de los archivos candidatos a ser eliminados
# Comprobar la eficacia de Listadofdupes.sh

unicos="/mnt/Multimedia/AAA"
repetidos="/mnt/Multimedia/AAB"

cd $unicos
ls -d */ | cut -f1 -d'/' > subs
sort subs | uniq | grep -v '^$' > subs_sort
# find $repetidos/* -print -exec touch {} \;
while read directorio
 do
  originales="$unicos/$directorio"
  duplicados="$repetidos/$directorio"
  printf "\nComprobando directorios ... \n"
  [ -d $originales ] && printf "%s encontrado\n" $originales &&  [ -d $duplicados ] && printf "%s encontrado\n" $duplicados && Listadofdupes.sh $originales $duplicados $directorio || exit 0
  printf "\nContiuar [si/no]\n"
  read continuar_sn
  [[ "$continuar_sn" = 'no' ]] && exit 0
 done < subs_sort
