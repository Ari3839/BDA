#!/bin/bash
# @Autor		Ariadna Lazaro Mtz
# @Fecha		30/ago/2023
# @Descripcion		Creación de directorios

echo "Validando existencia de directorio para datafiles"
export ORACLE_SID=aalmbda2

if [ -d "/u01/app/oracle/oradata/${ORACLE_SID^^}" ]; then
  echo "El directorio para datafiles ya existe"
else
  echo "Creando directorio para data files"
    cd /u01/app/oracle/oradata/
    mkdir ${ORACLE_SID^^}
    chown oracle:oinstall ${ORACLE_SID^^}
    chmod 750 ${ORACLE_SID^^}
fi;

echo "Creando carpeta para redologs y control files"
if [ -d "/unam-bda/d01/app/oracle/oradata/${ORACLE_SID^^}" ]; then
  echo "El directorio d01 para redologs y control files ya existe"
else
  echo "creando directorio d01"
    cd /unam-bda/d01
    mkdir -p app/oracle/oradata/${ORACLE_SID^^}
    chown -R oracle:oinstall app
    chmod -R 750 app
fi;

if [ -d "/unam-bda/d02/app/oracle/oradata/${ORACLE_SID^^}" ]; then
  echo "El directorio d02 para redologs y control files ya existe"
else
  echo "creando directorio d02"
    cd /unam-bda/d02
    mkdir -p app/oracle/oradata/${ORACLE_SID^^}
    chown -R oracle:oinstall app
    chmod -R 750 app
fi;

if [ -d "/unam-bda/d03/app/oracle/oradata/${ORACLE_SID^^}" ]; then
  echo "El directorio d03 para redologs y control files ya existe"
else
  echo "creando directorio d03"
    cd /unam-bda/d03
    mkdir -p app/oracle/oradata/${ORACLE_SID^^}
    chown -R oracle:oinstall app
    chmod -R 750 app
fi;

echo "Comprobando directorios para datafiles"
ls -l /u01/app/oracle/oradata/ | grep ${ORACLE_SID^^}
echo "Comprobando directorios para redologs y controlfiles"
ls -l /unam-bda/d0*/app/oracle/oradata
