#!/bin/bash

# call with ./report_parser.sh <report file>
#cat $1 | sed -n 's/.*\(CVE-[0-9]+-[0-9]\+\).*/\1/' | grep "CVE-" | sort | uniq | awk '{printf("\"%s\" ", $0)}'
#cat $1 | egrep -o 'CVE-[0-9]+-[0-9]+' | sort | uniq | awk '{printf("\"%s\" ", $0)}'
cat $1 | egrep -o 'CVE-[0-9]+-[0-9]+' | sort | uniq | awk 'BEGIN{printf("[")}{printf("%s, ", $0)}END{printf("]")}'
echo
