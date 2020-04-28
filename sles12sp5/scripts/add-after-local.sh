#!/bin/bash

if [ /etc/init.d/after.local ]; then
cat >> /etc/init.d/after.local <<"END"
if [ -f /usr/sbin/SUSEConnect ]; then
        SUSEConnect --status | grep -E ".*SLES.*version.*Not Registered.*"

        if [ $? -eq 0 ]; then
                /usr/sbin/SUSEConnect --write-config --url https://test-suse-rmt.exoscale.org &>/dev/null

                if [ $? -eq 0 ]; then
                        SUSEConnect -p sle-module-web-scripting/12/x86_64
                        SUSEConnect -p sle-module-toolchain/12/x86_64
                        SUSEConnect -p sle-module-legacy/12/x86_64
                        SUSEConnect -p sle-sdk/12.5/x86_64
                        SUSEConnect -p sle-module-public-cloud/12/x86_64
                        SUSEConnect -p sle-module-containers/12/x86_64
                        SUSEConnect -p sle-module-adv-systems-management/12/x86_64
			zypper ref
			sleep 10
                        SUSEConnect -p PackageHub/12.5/x86_64 || SUSEConnect -p PackageHub/12.5/x86_64
                else
                        exit 1
                fi
        fi
fi
END
fi
