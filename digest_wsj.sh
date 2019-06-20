#!/usr/bin/env bash

WSJ_URL=$(expand_url.sh $1)
ANSWER_URL=$(expand_url.sh $2)
ANSWER_ID=$(basename -s .pdf ${ANSWER_URL})

CONTENTS=$(curl -s ${WSJ_URL})
TITLE=$(echo ${CONTENTS} | xmllint --html --xpath "//h1/text()" - 2>/dev/null)
DESCRIPTION=$(echo ${CONTENTS} | xmllint --html --xpath "(//h2)[1]/text()" - 2>/dev/null)

FILENAME="$(date --iso-8601) ${TITLE} (${ANSWER_ID})"

echo ${FILENAME}
echo
echo ${TITLE}
echo
echo ${DESCRIPTION}
echo
echo ${WSJ_URL}
echo
echo ${ANSWER_URL}
