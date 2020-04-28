#!/bin/bash

pam-config -a --cracklib --cracklib-minlen=8 --cracklib-lcredit=-1 \
	--cracklib-ucredit=-1 --cracklib-dcredit=-1 \
	--cracklib-ocredit=-1 --cracklib-minclass=3 \
	--cracklib-retry=5 --cracklib-difok=4 \
	--pwhistory --pwhistory-use_authtok \
	--pwhistory-remember=3 --cracklib-enforce_for_root
