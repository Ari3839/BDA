--@Autor: 	Ariadna Lázaro
--@Fecha: 	06-sept-2023
--@Descripcion:	Comparando esquemas

whenever sqlerror exit rollback;

Prompt conectando como ariadna0302
connect ariadna0302/ariadna

create table t03_datos_sesion (
  usuario varchar2(128),
  nombre_esquema varchar2(128)
);

Prompt otorgando permisos a usuario public
connect sys/Hola1234# as sysdba
grant insert,select on ariadna0302.t03_datos_sesion to public;

Prompt insertando datos como sysadmin
connect ariadna0302/ariadna as sysdba

insert into ariadna0302.t03_datos_sesion
(usuario,nombre_esquema) values(
  sys_context('USERENV','CURRENT_USER'),
  sys_context('USERENV','CURRENT_SCHEMA')
);

Prompt insertando datos como sysoper
connect ariadna0303/ariadna as sysoper

insert into ariadna0302.t03_datos_sesion
(usuario,nombre_esquema) values(
  sys_context('USERENV','CURRENT_USER'),
  sys_context('USERENV','CURRENT_SCHEMA')
);


Prompt insertando datos como sysbackup
connect ariadna0304/ariadna as sysbackup

insert into ariadna0302.t03_datos_sesion
(usuario,nombre_esquema) values(
  sys_context('USERENV','CURRENT_USER'),
  sys_context('USERENV','CURRENT_SCHEMA')
);


col usuario format a30
col nombre_esquema format a30
select * from ariadna0302.t03_datos_sesion;

Prompt quitando privilegios
connect sys/"Hola1234#" as sysdba

revoke sysdba from ariadna0302;
revoke sysoper from ariadna0303;
revoke sysbackup from ariadna0304;

alter user sys identified by system1;

