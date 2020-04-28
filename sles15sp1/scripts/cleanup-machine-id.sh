#!/bin/bash

echo ** "reset machine settings"
rm -f /etc/machine-id
touch /etc/machine-id
rm -f /var/lib/zypp/AnonymousUniqueId
rm -f /var/lib/dbus/machine-id
touch /var/lib/dbus/machine-id
rm -rf /var/adm/autoinstall
