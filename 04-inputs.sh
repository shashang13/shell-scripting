#!/usr/bin/bash

read -p 'Provide your name: ' name
echo "Your Name is ${name}"

#Special Variables
# $0 - $n
# $* or S@
# $#

echo "Script Name = $0"
echo "First Arg = $1"
echo "Second Arg = $2"
echo "All Args = $*"
echo "No. of Args = $#"

