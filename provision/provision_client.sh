#!/bin/bash

#Detenemos ejecucion si falla algun comando
set -e

#Actualizamos e instalamos el cliente y las herramientas de red
apt update -y
apt install -y net-tools iproute2 isc-dhcp-client

#Mostramos mensaje de que todo ha ido bien y las interfaces ip para revisar que cada ciente tenga la ip correcta
echo "Configuración de cliente lista."
dhclient -v
ip a


