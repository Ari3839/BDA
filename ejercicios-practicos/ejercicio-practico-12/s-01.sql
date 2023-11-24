-- @Autor:  Ariadna Lázaro
-- @Fecha:  23/11/2023
-- @Descripcion:Admininstración de redo logs

!find /unam-bda/d0*/app/oracle/oradata/AALMBDA2 -name "*.log" 2>/dev/null

select group#,sequence#,round(bytes/1024/1024) as tam_mb,
blocksize,members,status,first_change#,
to_char(first_time,'dd/mm/yyyy hh24:mi:ss'),next_change#
from v$log;

select group#,status,type,member
from v$logfile;

--El status es nulo porque está en uso dicho grupo.
--También pueden tener status inválido (archivo inaccesible)
--stale: contenido incompleto
--o deleted: ya no se usa el archivo

alter database add logfile group 4
('/unam-bda/d01/app/oracle/oradata/AALMBDA2/redo04a.log',
'/unam-bda/d02/app/oracle/oradata/AALMBDA2/redo04b.log')
size 80m blocksize 512;

alter database add logfile group 5
('/unam-bda/d01/app/oracle/oradata/AALMBDA2/redo05a.log',
'/unam-bda/d02/app/oracle/oradata/AALMBDA2/redo05b.log')
size 80m blocksize 512;

alter database add logfile group 6
('/unam-bda/d01/app/oracle/oradata/AALMBDA2/redo06a.log',
'/unam-bda/d02/app/oracle/oradata/AALMBDA2/redo06b.log')
size 80m blocksize 512;

alter database add logfile member 
'/unam-bda/d03/app/oracle/oradata/AALMBDA2/redo04c.log'
to group 4;

alter database add logfile member 
'/unam-bda/d03/app/oracle/oradata/AALMBDA2/redo05c.log'
to group 5;

alter database add logfile member 
'/unam-bda/d03/app/oracle/oradata/AALMBDA2/redo06c.log'
to group 6;

select group#,sequence#,round(bytes/1024/1024) as tam_mb,
blocksize,members,status,first_change#,
to_char(first_time,'dd/mm/yyyy hh24:mi:ss'),next_change#
from v$log;

select group#,status,type,member
from v$logfile;

alter system switch logfile;

select group#,sequence#,round(bytes/1024/1024) as tam_mb,
blocksize,members,status,first_change#,
to_char(first_time,'dd/mm/yyyy hh24:mi:ss'),next_change#
from v$log;

alter system checkpoint;

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

select group#,sequence#,round(bytes/1024/1024) as tam_mb,
blocksize,members,status,first_change#,
to_char(first_time,'dd/mm/yyyy hh24:mi:ss'),next_change#
from v$log;

--rm -rf

!find /unam-bda/d0*/app/oracle/oradata/AALMBDA2. -name "*.log" 2>/dev/null