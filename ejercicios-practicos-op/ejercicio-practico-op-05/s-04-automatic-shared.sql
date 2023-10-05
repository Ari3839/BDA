-- @Autor:  Ariadna Lázaro
-- @Fecha:  04/10/2023
-- @Descripcion: Cambio de administración automática->semi

Prompt Conectando como sys
connect sys/system2 as sysdba

Prompt modificando a admininstración semiautomática
alter system set sga_target=500M scope=memory;
alter system set pga_aggregate_target=282 scope=memory;
alter system set memory_target=0 scope=memory;

Prompt Esperando 5 seg. para que el cambio tome efecto a nivel instancia
exec dbms_session.sleep(5)

insert into ariadna05op.t02_memory_param_values (id,sample_date,
  memory_target,sga_target,pga_aggregate_target,
  shared_pool_size,large_pool_size,java_pool_size,db_cache_size) 
values (2,
    (select current_date from dual),
    (select round(value/1024/1024,2) from v$parameter 
      where name='memory_target'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='sga_target'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='pga_aggregate_target'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='shared_pool_size'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='large_pool_size'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='java_pool_size'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='db_cache_size')
  ); 

commit;

Prompt mostrando datos hasta el momento de t02_memory_param_values
set linesize window
select * from ariadna05op.t02_memory_param_values;
