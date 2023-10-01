-- @Autor:	Ariadna Lázaro
-- @Fecha:	17/09/2023
-- @Descripción:Restaurar los parametros modificados

Prompt Conectando como sys
connect sys/system2 as sysdba

--En caso de error
whenever sqlerror exit rollback

Prompt revirtiendo valores de los parametros
--Los valores modificados a nivel sesión no cambian permanentemente
--a. nivel sesion
--b
alter system reset db_writer_processes;
--c
alter system reset log_buffer;
--d
alter system reset db_files;
--e
alter system reset dml_locks;
--f
alter system reset transactions;
--g
alter system reset hash_area_size;
--h a nivel sesion
--i a nivel instancia
--j
alter system reset optimizer_mode;
--k a nivel sesion

Prompt Reiniciando instancia posterior a restaurar los parámetros
pause Presiona ENTER para continuar

shutdown immediate

#Prompt creando spfile
#create spfile from pfile='/unam-bda/ejercicios-practicos/ejercicio-practico-06/e-02-spparameter-pfile.txt';

Prompt shutdown completo, iniciando
startup

Prompt Listo!
exit
