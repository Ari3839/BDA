-- @Autor:  Ariadna Lázaro
-- @Fecha:  21/11/2023
-- @Descripcion:Asignando quotas

Prompt conectando como usuario sys
connect sys/system2 as sysdba

Prompt otorgando quotas
alter user ariadna11 quota unlimited on store_tbs1;
alter user ariadna11 quota unlimited on store_tbs_custom;
alter user ariadna11 quota unlimited on store_tbs_multiple;
alter user ariadna11 quota unlimited on store_tbs_zip;
alter user ariadna11 quota unlimited on store_tbs_temp;
alter user ariadna11 quota 50M on store_tbs_big;

alter user ariadna11 default tablespace store_tbs1;
alter user ariadna11 temporary tablespace store_tbs_temp;



declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA11';
  v_tablename varchar2(50):='STORE_TEST';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt conectando como ariadna11
connect ariadna11/ariadna


Prompt creando tabla y comprobando espacio
create table store_test(
  id number(3,0)
);


set serveroutput on

declare
  v_extensiones number;
  v_total_espacio number;
begin
  v_extensiones := 0;
  loop
  begin
    execute immediate 'alter table store_test allocate extent';
    exception
    when others then
	  if sqlcode = -1653 then
        exit;
      end if;
    end;
  end loop;
--total espacio asignado
select sum(bytes)/(1024*1024),count(*) into v_total_espacio,v_extensiones
from user_extents
where segment_name='STORE_TEST';
dbms_output.put_line('Total de extensiones creadas: '||v_extensiones);
dbms_output.put_line('Total de espacio reservado: '||v_total_espacio);
end;
/

Prompt conectando como usuario sys
connect sys/system2 as sysdba

Prompt agregando datafile
alter tablespace store_tbs1
  add datafile '/u01/app/oracle/oradata/AALMBDA2/store_tbs2.dbf' size 5m;

Prompt conectando como ariadna11
connect ariadna11/ariadna

Prompt comprobando espacio
insert into store_test(id) values(1);
insert into store_test(id) values(2);


