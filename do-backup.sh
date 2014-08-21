#!/bin/sh

#set -x

APPLIST=applist-$(hostname)-$(date +'%Y%m%d').txt
APPBKDIR=appbackup-$(hostname)

if [ `whoami` != root ]; then
    SUDO=sudo
else
    SUDO=""
fi

if [ ! -e ${APPLIST} ]; then
    echo "INFO: Creating ${APPLIST}"
    ${SUDO} find / -name "*.app" -print >$APPLIST
fi

mkdir -p ${APPBKDIR}

(while read line; do
    echo "INFO: Processing ${line}"
    dn=$(dirname "${line}")
    entry=$(basename "${line}")
    mkdir -p "${APPBKDIR}/${dn}"
    (cd "${dn}" && ${SUDO} tar -cz "${entry}") >"${APPBKDIR}/${dn}/${entry}.tar.gz"
done) < ${APPLIST}

# EOF
