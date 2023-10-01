-- @Autor:	Ariadna Lázaro
-- @Fecha:	17/09/2023
-- @Descripcion:Obteniendo parametros de instancia

Prompt conectando como sys
connect sys/system2 as sysdba

--En caso de error
whenever sqlerror exit rollback

create table ariadna06.t02_other_parameters as
  select num,name,value,default_value,
  isses_modifiable as is_session_modifiable,
  issys_modifiable as is_system_modifibale
  from v$system_parameter
  where name in(
    'cursor_invalidation','optimizer_mode','sql_trace',
    'sort_area_size','hash_area_size','nls_date_format',
    'db_writer_processes','db_files','dml_locks',
    'log_buffer','transactions'
);

select * from ariadna06.t02_other_parameters;

exit;

