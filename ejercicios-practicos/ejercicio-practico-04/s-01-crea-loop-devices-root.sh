#!/bin/bash
# @Autor		Ariadna Lazaro Mtz
# @Fecha		28/ago/2023
# @Descripcion		Creación de loops como simulacion de particiones
US=$(id -un)

if [ "${US}" == "root" ]; then
  echo "--Ejecutando como usuario root--"

  echo "Creando directorio disk-images"
  aux=$(( `ls -l /unam-bda | grep disk-images | wc -l` ))
  if [ "${aux}" == 1 ]; then
    echo "!!Ya existe la carpeta"
  else
    mkdir /unam-bda/disk-images
  fi;

  echo "Creando archivos binarios"
  cd /unam-bda/disk-images
  aux=$(( `ls -l | grep disk | wc -l` ))
  if [ "${aux}" == 3 ]; then
    echo "!!Ya existen los binarios"
  else
    #disk1.img
    dd if=/dev/zero of=disk1.img bs=100M count=10
    #disk2.img
    dd if=/dev/zero of=disk2.img bs=100M count=10
    #disk3.img
    dd if=/dev/zero of=disk3.img bs=100M count=10
  fi;

  echo "Binarios obtenidos:"
  du -sh disk*.img

  aux=$(( `losetup -a | grep /unam-bda/disk-images | wc -l` ))
  if [ "${aux}" == 3 ]; then
    echo "!!Ya existem los dispositivos loop"
  else
    echo "Creando loop device para disk1.img"
    losetup -fP disk1.img #-f ubica al primer loop device available y -P refresh

    echo "Creando loop device para disk2.img"
    losetup -fP disk2.img

    echo "Creando loop device para disk3.img"
    losetup -fP disk3.img
  fi;

  echo "Conprobando la asociación a dispositivo"
  losetup -a

  echo "Formateando archivos"
  mkfs.ext4 disk1.img
  mkfs.ext4 disk2.img
  mkfs.ext4 disk3.img

  echo "Creando punto de montaje"
  aux=$(( `ls -l /unam-bda | grep d0 | wc -l` ))
  if [ "${aux}" -ge 3 ]; then
    echo "!!Ya existen las carpetas para montar los discos"
  else
      mkdir /unam-bda/d01
      mkdir /unam-bda/d02
      mkdir /unam-bda/d03
  fi;

  echo "Agregando al archivo fstab"
  aux=$(( `tail -3 /etc/fstab | grep /unam-bda | wc -l` ))
  if [ "${aux}" -ge 3 ]; then
    echo "!!Montajes previamente añadidos"
  else
    echo "/unam-bda/disk-images/disk1.img /unam-bda/d01 auto loop 0 0" >> /etc/fstab
    echo "/unam-bda/disk-images/disk2.img /unam-bda/d02 auto loop 0 0" >> /etc/fstab
    echo "/unam-bda/disk-images/disk3.img /unam-bda/d03 auto loop 0 0" >> /etc/fstab
  fi;

  echo "Comprobando puntos de montaje"
  sudo mount -a
  sudo mount | grep unam-bda

  echo "Segunda comprobacion de los puntos de montaje"
  df -h | grep unam-bda

  echo "Listo"
else
  echo "No estas autenticado como usuario root"
fi;
