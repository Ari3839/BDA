-- @Autor:  Ariadna Lázaro
-- @Fecha:  24/11/2023
-- @Descripcion:Datos undo pt3:Snapshot too old

--ariadna072/ariadna

set transaction isolation level serializable name 'T1-LR';

select count(*) from ariadna072_cadena_2;
select count(*) from ariadna072_cadena_2
where cadena like 'A%' or cadena like 'Z%' or cadena like 'M%';

--Consulta para dar prioridad a datos undo:
alter tablespace undotbs2 retention guarantee;
