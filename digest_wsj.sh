#!/bin/sh

WSJ_URL=$(expand_url.sh $1)
ANSWER_URL=$(expand_url.sh $2)

get_subject_from_wsj.sh ${WSJ_URL}

echo

echo ${WSJ_URL}
echo
echo ${ANSWER_URL}
