-- @Autor:  Ariadna Lázaro
-- @Fecha:  24/11/2023
-- @Descripcion:Datos undo pt4:Snapshot too old

--ariadna072/ariadna

delete from ariadna072_cadena_2 where id<=5000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=10000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=15000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=20000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=25000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=30000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=35000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=40000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=45000;
commit;
--Coonsulta
delete from ariadna072_cadena_2 where id<=50000;
commit;
--Coonsulta

--¿Cuántas instrucciones delete se tuvieron que ejecutar para provocar el error?


