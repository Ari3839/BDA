#!/bin/bash
# @Autor 	Ariadna Lázaro
# @Fecha 	13/09/2023
# @Descripcion 	Descargar una lista de imágenes de Internet y comprimirlas

archivoImagenes="${1}"
numImagenes="${2}"
archivoZip="${3}"

function ayuda(){
  #parámetro que contiene el código de salida.
  codigo="${1}"
  cat s-02-ayuda.sh
  exit "${codigo}"
}

#Error 100 archivo txt no espcificado
if [ -z "${archivoImagenes}" ]; then
  echo "ERROR: El nombre del archivo txt no fue especificado"
  ayuda 100
else
  #Error 101 archivo inexistente
  if ! [ -f "${archivoImagenes}" ]; then
    echo "ERROR: El archivo de imágenes ${archivoImagenes} no existe"
    ayuda 101
  fi
fi

#Error 102 rango incorrecto
# Observar que se emplea la expresión ~[0-9] para validar que el parámetro
# numImagenes sea númerico y que se encuentre en el rango (0,90]
if ! [[ "${numImagenes}" =~ [0-9]+ && "${numImagenes}" -ge 1 && "${numImagenes}" -le 90 ]]; then
  echo "ERROR: Número de imágenes es incorrecto."
  ayuda 102
fi;

#Si se especifica nombre para zip
if [ -n "${archivoZip}" ]; then
  dirSalida=$(dirname "${archivoZip}")
  nombreZip=$(basename "${archivoZip}")

  #Error 103, directorio para zip inexistente
  if ! [ -d "${dirSalida}" ]; then
    echo "ERROR: El directorio para crear el zip no existe"
    ayuda 103
  fi;

#Si no se especifica el nombre del zip
else
  dirSalida="/tmp/${USER}/imagenes"
  mkdir -p "${dirSalida}"
  nombreZip="imagenes-$(date '+%Y-%m-%d-%H-%M-%S').zip"
fi;

echo "Obteniendo imágenes, serán guardadas en ${dirSalida}"

rm -rf "${dirSalida}"/*

#Lectura del txt
count=0
while read -r linea
do
  if [ "${count}" -ge "${numImagenes}" ]; then
    echo "Total de imágenes obtenidas ${count}"
    break;
  fi;
  #-q = quiet
  #-P <dir> indica el directorio de descarga
  #-c = continue. Si el archivo ya existe descargado parcialmente, se completa
  wget -q -P "${dirSalida}" "${linea}"
  status=$?
  if ! [ ${status} -eq 0 ]; then
    echo "ERROR al obtener la imagen ${linea}"
    ayuda 104
  fi;
  count=$((count+1))
  echo "Imagen ${count} obtenida"
done < "${archivoImagenes}"

#Creando el zip
export IMG_ZIP_FILE="${dirSalida}/${nombreZip}"
echo "Generando archivo zip en ${IMG_ZIP_FILE}"
rm -f "${IMG_ZIP_FILE}"
# -j No incluir la lista de subdirectorios
zip -j "${IMG_ZIP_FILE}" "${dirSalida}"/*
echo "Cambiando permisos al archivo zip"
chmod 600 "${IMG_ZIP_FILE}"

echo "Generando archivo con lista de imágenes"
rm -f "${dirSalida}"/s-00-lista-archivos.txt

# La opción Z1 muestra solo los nombres de los archivos contenidos
unzip -Z1 "${IMG_ZIP_FILE}" > "${dirSalida}"/s-00-lista-archivos.txt

# -I {}reemplaza "{}" con la salida del comando unzip.
unzip -Z1 "${IMG_ZIP_FILE}" | xargs -I {} rm "${dirSalida}"/{}
