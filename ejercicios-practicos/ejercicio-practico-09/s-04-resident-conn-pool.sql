-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/10/2023
-- @Descripcion:Pool de conexiones

Prompt conectando como usuario sys
connect sys/system2 as sysdba

Prompt iniciando al SYS_DEFAULT_CONNECTION_POOL
exec dbms_connection_pool.start_pool();

Prompt configurando parametros del pool
--El primer parametro es para el nombre, para usar el default=''
exec dbms_connection_pool.alter_param ('','MAXSIZE','50');
exec dbms_connection_pool.alter_param ('','MINSIZE','35');
--Tiempo máximo de permanancia de la conexión en pool si no se usa (default=300)
exec dbms_connection_pool.alter_param ('','INACTIVITY_TIMEOUT','1800');
--Tiempo máximo que se acepta la conexión con usuario inactivo
exec dbms_connection_pool.alter_param ('','MAX_THINK_TIME','1800');

--Debe existir el servicio ORACLE_SID_POOLED en tnsnames.ora
