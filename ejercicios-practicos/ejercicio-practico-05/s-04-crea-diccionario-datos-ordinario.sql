-- @Autor		Ariadna Lazaro Mtz
-- @Fecha		30/ago/2023
-- @Descripcion	Creación de la BD

--ORACLE_SID

Prompt Conectando como sys
connect sys/system2 as sysdba

@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql
@?/rdbms/admin/utlrp.sql

Prompt conectando como system
connect system/system2
@?/sqlplus/admin/pupbld.sql

Prompt Listo
exit
