#!/bin/bash

# check for envsubst
which ${DEPLOY_ENVSUBST_COMMAND:-envsubst} > /dev/null 2>&1

if [[ $? == 0 ]] ; then
	echo [ok] Found "envsubst"
	exit 0
fi

echo
echo Error: Unable to find "envsubst".
echo
echo Please make sure "envsubst" is installed and accessible via \$PATH:
echo
echo Linux: Install "gettext" via standard package managers, e.g.
echo "       > yum install -y gettext"
echo
echo MacOS: Install with "brew" and set \$DEPLOY_ENVSUBST_COMMAND, e.g.
echo "       > brew install gettext"
echo "       > export DEPLOY_ENVSUBST_COMMAND=\"/usr/local/Cellar/gettext/0.19.8.1/bin/envsubst\""
echo

exit 1
