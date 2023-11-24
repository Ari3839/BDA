-- @Autor:  Ariadna Lázaro
-- @Fecha:  21/11/2023
-- @Descripcion:Consultas

Prompt conectando como usuario sys
connect sys/system2 as sysdba

set linesize window
col username format a20
col default_tablespace format a20

select tablespace_name,block_size,initial_extent,
next_extent,min_extlen,status,contents,logging
from dba_tablespaces;

select tablespace_name,extent_management,
segment_space_management,bigfile,encrypted
from dba_tablespaces;

select u.username as username,u.default_tablespace as default_tablespace,
u.temporary_tablespace as temporary_tablespace,
case 
  when t.max_bytes=-1 then 'unlimited'
  else to_char(round(t.max_bytes/1024/1024,2))
end as quota_mb,
round(t.bytes/1024/1024) as allocated_mb,t.blocks as blocks
from dba_users u join dba_ts_quotas t
on u.username=t.username
where t.username='ARIADNA11';