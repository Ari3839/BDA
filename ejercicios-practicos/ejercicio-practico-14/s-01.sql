-- @Autor:  Ariadna Lázaro
-- @Fecha:  24/11/2023
-- @Descripcion:Datos undo

Prompt conectando como usuario sys
connect sys/system2 as sysdba

--A
show parameter undo_tablespace;

select name,value from v$parameter where name='undo_tablespace';

--B
create undo tablespace undotbs2
  datafile '/u01/app/oracle/oradata/AALMBDA2/undotbs_2.dbf' size 30m
  autoextend off
  extent management local autoallocate;

--C
alter system set undo_tablespace=undotbs2 scope=memory;


