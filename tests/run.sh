#!/bin/bash

errors=0

basedir="$(dirname $0)"
validate_script="$basedir/validate_csv.sh"

cat "$basedir/../data/weapons.csv" | "$validate_script" \
    12 \
    "r'\d+'" \
    "r'.+'" \
    "r'.+'" \
    "r'Energy|Kinetic|Power'" \
    "r'Exotic|Legendary'" \
    "r'\d*'" \
    "r'\d*'" \
    "r'\d*'" \
    "r'\d*'" \
    "r'\d*'" \
    "r'\d*'" \
    "r'^$|^.*\.(jpg|png)$'"
[ "$?" -ne 0 ] && {
    echo "Validation failed for 'weapons.csv'" 2>&1
    let errors+=1
}

[ "$errors" -gt 0 ] && {
    echo "Found $errors validation error(s)" 2>&1
    exit 1
} || {
    echo "Validation successful" 2>&1
    exit 0
}
