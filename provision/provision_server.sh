#!/bin/bash

#Paramos si falla algun comando para verlo
set -e

#Mensaje por pantalla y parametro -y para evitar necesidad de confirmacion
echo "Instalando servidor DHCP..."
apt update -y
#Instalamos el dhcp y las herramientas necesarias
apt install -y isc-dhcp-server net-tools iproute2

# Interfaz donde escuchará el servicio (la red interna)
INTERFACE=$(ip -o -4 addr show | awk '/192\.168\.57\./ {print $2}')
sed -i "s/^INTERFACESv4=.*/INTERFACESv4=\"$INTERFACE\"/" /etc/default/isc-dhcp-server

# Copia de seguridad del archivo de configuración por si es necesaria
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

# Configuración del servicio DHCP
cat > /etc/dhcp/dhcpd.conf <<EOF
default-lease-time 86400;
max-lease-time 691200;
authoritative;

subnet 192.168.57.0 netmask 255.255.255.0 {
  range 192.168.57.25 192.168.57.50;
  option routers 192.168.57.10;
  option broadcast-address 192.168.57.255;
  option domain-name-servers 8.8.8.8, 4.4.4.4;
  option domain-name "micasa.es";
}

# Cliente c2 - IP fija por MAC
host c2 {
  hardware ethernet 08:00:27:aa:bb:cc;
  fixed-address 192.168.57.31;
  option domain-name-servers 1.1.1.1;
  default-lease-time 3600;
}
EOF

# Reiniciar y habilitar servicio
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server

#Comprobamos estado del servicio y evatimos salida paginada para automatizar
echo "Comprobando estado del servicio..."
systemctl status isc-dhcp-server --no-pager

