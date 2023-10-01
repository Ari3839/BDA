#!/bin/bash
# @Autor		Ariadna Lazaro Mtz
# @Fecha		28/ago/2023
# @Descripcion		Creación del archivo PFile

echo "Creando un archivo de parámetros básico"
export ORACLE_SID=aalmbda2
export US=$(id -un)

if [ "${US}" == "oracle" ]; then
  echo "--Ejecutando como usuario oracle--"

  #variable
  pfile=${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora

  if [ -f "${pfile}" ]; then
    read -p "El archivo ${pfile} ya existe, [enter] para sobrescribir"
  fi;

  echo \
     "db_name='${ORACLE_SID}'
     memory_target=768M
     control_files=(
       /unam-bda/d01/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
       /unam-bda/d02/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
       /unam-bda/d03/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl
     )" > "$pfile"
  echo "Listo"
  echo "Comprobando el contenido del archivo PFILE"
  cat "${pfile}"
else
  echo "No estas autenticado como usuario oracle"
fi;
