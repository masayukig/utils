#!/bin/sh

#set -x
#subject=`curl -s $1 | xmllint --html --xpath "//h1/text()"`
#echo $subject
CONTENTS=$(curl -s ${1})
echo ${CONTENTS} | xmllint --html --xpath "//h1/text()" - 2>/dev/null
#curl -s $1 | xmllint --html --xpath "//h1/text()" - 2>/dev/null
echo
echo ${CONTENTS} | xmllint --html --xpath "(//h2)[1]/text()" - 2>/dev/null
#curl -s $1 | xmllint --html --xpath "(//h2)[1]/text()" - 2>/dev/null
