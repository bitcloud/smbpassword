#!/bin/bash
# author: Jan Schmidle jan@jschmidle.org 2020
# based script from on author: Tim Wahrendorff 2016
# licence: Public Domain - https://wiki.creativecommons.org/wiki/Public_domain
#
# To use this script you need at least:
# sudo apt-get install rpcclient
#

OP="${1}"
DC="${2}"
USER="${3}"

if [[ $# -ne 3 ]]; then
    echo "usage: ${0} {operation} {domain-controller} {username}"
    echo "operation is one of check or change"
    exit 1
fi

if [ "${OP}" == "change" ]
then
  echo "Changing password on ${DC} for user ${USER} ..."
  smbpasswd -U "${USER}" -r "${DC}" || exit 100
  exit 0
fi

echo "Getting user information from ${DC} for user ${USER} ..."

echo -n "Password: "
read -s PASS
echo
echo

### START RPCCLIENT query
if [ "x$USERDCID" == "x" ]; then
    RPCLOOKUPID=$(rpcclient -U $USER%$PASS -c "lookupnames $USER" $DC)
    if [ $? -ne "0" ]
    then
        echo "Error loading UserId: ${RPCLOOKUPID}"
        exit 100
    fi

    USERDCID=$(echo "$RPCLOOKUPID" | grep -e '[0-9]\{4,9\} ' -o)
fi

QUERYUSER=$(rpcclient -U $USER%$PASS -c "queryuser $USERDCID" $DC)
if [ $? -ne "0" ]
then
    echo "Error loading User Information: ${QUERYUSER}"
    exit 100
fi

EXPDATE=$(echo "$QUERYUSER" | grep 'Password must change Time')
echo $EXPDATE

### END RPCCLIENT query