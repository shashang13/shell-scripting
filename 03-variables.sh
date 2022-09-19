#!/usr/bin/bash
a=100
b=200

#echo ${a}times
#echo $b

DATE=$(date +%F)
echo ${DATE}

TOTAL=$((b/a))
echo ${TOTAL}

#Scalar
c=10

#Arrays
d=(10 50 triangle square)

echo ${d[0]}
echo ${d[1]}
echo ${d[2]}
echo ${d[3]}
echo ${d[*]}

#Env variable
echo Training=${Training}