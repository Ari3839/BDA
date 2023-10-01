##@Autor: 	Ariadna Lázaro
##@Fecha: 	06-sept-2023
##@Descripcion:	Eliminar y copiar passwd

export ORACLE_SID=aalmbda1
export US=$(id -un)


#Comprobando usuario
if [ "${US}" == "oracle" ]; then
  echo "--Ejecutando como usuario oracle--"

  #Creando carpeta backups
  if [ -d "/home/oracle/backups" ]; then
    echo "Carpeta creada con anterioridad"
  else
    echo "Creando carpeta de respaldo"
    mkdir /home/oracle/backups
  fi;

  #Moviendo el archivo de passwords
  if [ -f "${ORACLE_HOME}/dbs/orapw${ORACLE_SID}" ]; then
    mv "${ORACLE_HOME}"/dbs/orapwaalmbda1 /home/oracle/backups
  else
    echo "El archivo de passwords ya no se encuentra en donde deberia"
  fi;
  
  #El comando read obliga a capturar una entrada en teclado.
  #En caso de no querer continuar, detener ejecución con Ctrl+C
  if [ -f "${ORACLE_HOME}/dbs/orapw${ORACLE_SID}" ]; then
    read -p "El archivo ya existe, [enter] para sobreescribir"
  fi;

  echo "creando el archivo"
  orapwd \
    FILE="${ORACLE_HOME}/dbs/orapw${ORACLE_SID}" \
    FORCE=Y \
    FORMAT=12.2 \
    SYS=password \
    SYSBACKUP=password

  echo "Comprobando archivo"
  ls -l ${ORACLE_HOME}/dbs/orapw${ORACLE_SID}

  echo "Listo"
else
  echo "No estas autenticado como usuario oracle"
fi;
