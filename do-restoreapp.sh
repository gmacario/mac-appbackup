#!/bin/sh
# Restore one or more applications from the app backup

# Uncomment the following lines to restore all apps from the last backup
#APPBKDIR=appbackup-$(hostname)
APPBASE=.
#APPRESTOREDIR=/

# Customize variables for debugging
APPBKDIR="${HOME}/Documents/mac-appbackup_mac-rita-20140821-part1/appbackup-mac-rita.local"
#APPBASE="Applications/Microsoft Office 2011"
#APPBASE="Applications/VLC.app.tar.gz"
APPRESTOREDIR=/tmp

#set -x

# Sanity checks
if [ "${APPBKDIR}" = "" ]; then
    echo "ERROR: Must define APPBKDIR"
    exit 1
fi
if [ ! -e "${APPBKDIR}" ]; then
    echo "ERROR: APPBKDIR does not exist"
    exit 1
fi 
if [ "${APPBASE}" = "" ]; then
    echo "ERROR: Must define APPBASE"
    exit 1
fi
if [ "${APPRESTOREDIR}" = "" ]; then
    echo "ERROR: Must define APPRESTOREDIR"
    exit 1
fi

if [ `whoami` != root ]; then
    SUDO="sudo"
else
    SUDO=""
fi

echo "INFO: Restoring apps from ${APPBKDIR}/${APPBASE}"
cd "${APPBKDIR}" 
find "${APPBASE}" -name "*.tar.gz" -print | while read line; do
    echo "INFO: Processing ${line}"
    dn=$(dirname "${line}")
    entry=$(basename "${line}")
    appname=$(echo "${entry}" | sed 's/.tar.gz//')
    ${SUDO} mkdir -p "${APPRESTOREDIR}/${dn}"
    if [ -e "${APPRESTOREDIR}/${dn}/${appname}" ]; then
        echo "WARNING: Skipping existing ${dn}/${appname}"
    else
        cat "${line}" | (cd "${APPRESTOREDIR}/${dn}" && ${SUDO} tar -xz)
    fi
done

# EOF
