-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/10/2023
-- @Descripcion:Revertir configuración del pool

Prompt conectando como usuario sys
connect sys/system2 as sysdba

Prompt finalizando al SYS_DEFAULT_CONNECTION_POOL
exec dbms_connection_pool.stop_pool();
exec dbms_connection_pool.restore_defaults();