#!/bin/bash

LINES=$1
RE_LIST=$(printf ",%s" "${@:2}")
RE_LIST=${RE_LIST:1}
read -r -d '' CMD <<EOF
import csv, sys, re
reader = csv.reader(sys.stdin, quotechar='"')
i = 1
rec = []
for r in [$RE_LIST]:
    rec.append(re.compile("^%s$" % r))
for row in reader:
    if len(row) != $LINES:
        print "Error, field count at line #%d: %s" % (i, row)
        exit(1)
    if i > 1:
        for f in range(min(len(row), len(rec))):
            if not rec[f].match(row[f]):
                print "Error, field match at line #%d, field #%d: %s" % (i, f+1, row)
                exit(1)
    i += 1
EOF
python -c "$CMD" < /dev/stdin
[ "$?" -ne 0 ] || {
    exit 1
}