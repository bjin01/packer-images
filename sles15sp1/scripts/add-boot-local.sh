#!/bin/bash

sed -i 's/After=basic.target/After=network.target/g' /usr/lib/systemd/system/rc-local.service
cat > /etc/init.d/boot.local <<"END"
#!/bin/bash
if [ -f /usr/sbin/SUSEConnect ]; then
        SUSEConnect --status | grep -E ".*SLES.*version.*Not Registered.*"

        if [ $? -eq 0 ]; then
                /usr/sbin/SUSEConnect --write-config --url https://test-suse-rmt.exoscale.org &>/dev/null

                if [ $? -eq 0 ]; then
			SUSEConnect -p sle-module-containers/15.1/x86_64
			SUSEConnect -p sle-module-python2/15.1/x86_64
			SUSEConnect -p PackageHub/15.1/x86_64
			SUSEConnect -p sle-module-legacy/15.1/x86_64
			SUSEConnect -p sle-module-public-cloud/15.1/x86_64
			SUSEConnect -p sle-module-web-scripting/15.1/x86_64
			SUSEConnect -p sle-module-transactional-server/15.1/x86_64
                else
                        exit 1
                fi
        fi
fi
END

chmod ugo+x /etc/init.d/boot.local

