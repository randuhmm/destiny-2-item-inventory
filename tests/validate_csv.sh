#!/bin/bash

LINES=$1
RE_LIST=$(printf ",%s" "${@:2}")
RE_LIST=${RE_LIST:1}
read -r -d '' CMD <<EOF
import csv, sys, re
quote_char = '"'
delim_char = ','
RED = "\033[1;31m"
RESET = "\033[1;0m"
def writeout(s):
  sys.stdout.write(s)
reader = csv.reader(sys.stdin, quotechar=quote_char)
i = 1
rec = []
for r in [$RE_LIST]:
    if r[0] != '^': r = '^' + r
    if r[-1] != '$': r = r + '$'
    rec.append(re.compile(r))
for row in reader:
    if len(row) != $LINES:
        writeout("%sError, field count at line #%d: %s\n" % (RED, i, RESET))
        writeout("%s\n" % delim_char.join(row))
        exit(1)
    if i > 1:
        for f in range(min(len(row), len(rec))):
            if not rec[f].match(row[f]):
                s = max(0, f-1)
                e = f+1
                pre = delim_char.join(row[:s]) + (delim_char if len(row[:s]) else '')
                post = (delim_char if len(row[e:]) else '') + delim_char.join(row[e:])
                writeout("%sError, field validation at line #%d, field #%d: %s\n" % (RED, i, f+1, RESET))
                writeout("%s%s%s%s%s\n" % (pre, RED, row[f], RESET, post))
                exit(1)
    i += 1
EOF
python -c "$CMD" < /dev/stdin
[ "$?" -ne 0 ] && {
    exit 1
} || {
    exit 0
}
