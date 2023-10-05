-- @Autor:  Ariadna Lázaro
-- @Fecha:  03/10/2023
-- @Descripcion: Execución del procedimiento almacenado

--Comprobando si ya existe la tabla 
Prompt Conectando como sys para reiniciar
connect sys/system2 as sysdba

shutdown immediate
startup

Prompt Conectando como usuario del ejericico
connect ariadna05op/ariadna

set timing on
exec spv_query_random_data
set timing off

Prompt Conectando como sys para ingresar otro registro en t01
connect sys/system2 as sysdba

insert into ariadna05op.t01_memory_areas(id,sample_date,
  redo_buffer_mb,buffer_cache_mb,shared_pool_mb,large_pool_mb,
  java_pool_mb,total_sga_mb1,total_sga_mb2,
  total_sga_mb3,total_pga_mb1,total_pga_mb2,max_pga) values(3,
    (select current_date from dual),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Redo Buffers'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Buffer Cache Size'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Shared Pool Size'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Large Pool Size'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Java Pool Size'),
    (select trunc(
      (
        (select sum(value) from v$sga)-
        (select current_size from v$sga_dynamic_free_memory)
      )/1024/1024,2) 
    from dual),
    (select trunc(
      (
        (select sum(current_size) from v$sga_dynamic_components) +
        (select value from v$sga where name ='Fixed Size') +
        (select value from v$sga where name ='Redo Buffers')
      ) /1024/1024,2) 
    from dual),
    (select trunc(
      (select sum(bytes) from v$sgainfo where name not in (
        'Granule Size',
        'Maximum SGA Size',
        'Startup overhead in Shared Pool',
        'Free SGA Memory Available',
        'Shared IO Pool Size')
      ) /1024/1024,2) 
    from dual),
    (select trunc(value/1024/1024,2) memoria_pga_1
      from v$pgastat where name ='aggregate PGA target parameter'),
    (select trunc(current_size/1024/1024,2) memoria_pga_2
      from v$sga_dynamic_free_memory),
    (select round(value/1024/1024,2) from v$pgastat 
      where name='maximum PGA allocated')
);

commit;


Prompt Mostrando contenido de la tabla t01_memory_areas
set linesize window
select id,sample_date,redo_buffer_mb,buffer_cache_mb,
  shared_pool_mb,large_pool_mb,java_pool_mb
from ariadna05op.t01_memory_areas;

select total_sga_mb1,total_sga_mb2,total_sga_mb3,
  total_pga_mb1,total_pga_mb2,max_pga
from ariadna05op.t01_memory_areas;
