#!/bin/bash
version=`grep "VERSION_ID=" /etc/os-release | cut -d "=" -f 2`
if [[ $version =~ .*12.* ]]; then
	echo "My IP address: \4{eth0}" >> /etc/issue
fi

