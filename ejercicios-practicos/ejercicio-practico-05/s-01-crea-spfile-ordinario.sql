-- @Autor		Ariadna Lazaro Mtz
-- @Fecha		28/ago/2023
-- @Descripcion		Creación del archivo SPFile desde el PFile
Prompt conectando como SYS desde archivo de passwords
--Como buena práctica, se omiten las contraseñas en texto plano
connect sys as sysdba

Prompt Creando spfile
Create spfile from pfile;

Prompt verificando creacion del archivo
!ls -l ${ORACLE_HOME}/dbs/spfileaalmbda2.ora

Prompt Listo
exit

-- ejecutar como ariadna
-- sqlplus /nolog
-- start s-01-crea-spfile-ordinario.sql
