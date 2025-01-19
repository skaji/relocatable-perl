#!/bin/bash

tempfile=$(mktemp)

"$@" >$tempfile 2>&1
exitstatus=$?

if [[ $exitstatus -ne 0 ]]; then
  cat $tempfile
fi
rm -f $tempfile

exit $exitstatus
