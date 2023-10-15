-- @Autor:  Ariadna Lázaro
-- @Fecha:  11/10/2023
-- @Descripcion:Configuración en modo compartido

Prompt conectando como usuario sys
connect sys/system2 as sysdba

alter system set dispatchers='(dispatchers=2)(protocol=tcp)' scope=memory;
alter system set shared_servers=4;

Prompt Mostrando valores modificados
show parameter dispatchers
show parameter shared_servers

alter system register;

Prompt Mostrando servicios del listener
!su oracle -c "lsnrctl services"
