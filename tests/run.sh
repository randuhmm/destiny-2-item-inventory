#!/bin/bash
set -e
errors=0

basedir="$(dirname $0)"
validate_script="$basedir/validate_csv.sh"

cat "$basedir/../data/weapons.csv" | "$validate_script" \
    12 \
    "r'[0-9]+'" \
    "r'.+'" \
    "r'.+'" \
    "r'Energy|Kinetic|Power'" \
    "r'Exotic|Legendary'"
[ "$?" -ne 0 ] || {
    echo "Validation failed for 'weapons.csv'" 2>&1
    let errors+=1
}

[ "$errors" -gt 0 ] && {
    echo "Found $errors validation error(s)"
    exit 1
}
