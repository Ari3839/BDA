#!/bin/bash
# @Autor		Ariadna Lazaro Mtz
# @Fecha		28/ago/2023
# @Descripcion		Creación del archivo de passwords

export ORACLE_SID=aalmbda2
export US=$(id -un)

if [ "${US}" == "oracle" ]; then
  echo "--Ejecutando como usuario oracle--"
  
  #El comando read obliga a capturar una entrada en teclado.
  #En caso de no querer continuar, detener ejecución con Ctrl+C
  if [ -f "${ORACLE_HOME}/dbs/orapw${ORACLE_SID}" ]; then
    read -p "El archivo ya existe, [enter] para sobreescribir"
  fi;

  echo "creando el archivo"
  orapwd \
    FILE=${ORACLE_HOME}/dbs/orapw${ORACLE_SID} \
    FORCE=Y \
    FORMAT=12.2 \
    SYS=password

  echo "Comprobando archivo"
  ls -l ${ORACLE_HOME}/dbs/orapw${ORACLE_SID}

  echo "Listo"
else
  echo "No estas autenticado como usuario oracle"
fi;
