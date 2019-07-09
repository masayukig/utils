#!/usr/bin/env bash

# https://stackoverflow.com/questions/44965524/scrap-articles-form-wsj-by-requests-curl-and-beautifulsoup

. ${HOME}/.wsj_credentials

login_url=$(curl -s -I "https://accounts.wsj.com/login")
connection=$(echo "$login_url" | grep -oP "location:\s+.*connection=\K(\w+)")
client_id=$(echo "$login_url" | grep -oP "location:\s+.*client_id=\K(\w+)")

OUTPUT_DIR=${HOME}/Nextcloud/Documents/English/Torael/follow-up

rm -f cookies.txt

IFS='|' read -r wa wresult wctx < <(curl -s 'https://sso.accounts.dowjones.com/usernamepassword/login' \
      --data-urlencode "username=$WSJ_USERNAME" \
      --data-urlencode "password=$WSJ_PASSWORD" \
      --data-urlencode "connection=$connection" \
      --data-urlencode "client_id=$client_id" \
      --data 'scope=openid+idp_id&tenant=sso&response_type=code&protocol=oauth2&redirect_uri=https%3A%2F%2Faccounts.wsj.com%2Fauth%2Fsso%2Flogin' | pup 'input json{}' | jq -r 'map(.value) | join("|")')

# replace double quote ""
wctx=$(echo "$wctx" | sed 's/&#34;/"/g')

code_url=$(curl -D - -s -c cookies.txt 'https://sso.accounts.dowjones.com/login/callback' \
     --data-urlencode "wa=$wa" \
     --data-urlencode "wresult=$wresult" \
     --data-urlencode "wctx=$wctx" | grep -oP "location:\s+\K(\S*)")

curl -s -c cookies.txt "$code_url"

# here call your URL loading cookies.txt
#curl -s -b cookies.txt "https://www.wsj.com/articles/singapore-prime-minister-lee-rejects-claims-he-misused-state-powers-in-family-feud-1499094761?tesla=y"

#exit

WSJ_URL=$(expand_url.sh $1)
ANSWER_URL=$(expand_url.sh $2)
ANSWER_ID=$(basename -s .pdf ${ANSWER_URL})

#CONTENTS=$(curl -s ${WSJ_URL})
CONTENTS=$(curl -s -b cookies.txt ${WSJ_URL})

TITLE=$(echo ${CONTENTS} | xmllint --html --xpath "//h1/text()" - 2>/dev/null)
DESCRIPTION=$(echo ${CONTENTS} | xmllint --html --xpath "(//h2)[1]/text()" - 2>/dev/null)

FILENAME="$(date --iso-8601) ${TITLE} (${ANSWER_ID})"

cd ${OUTPUT_DIR}
wget -q --no-use-server-timestamps ${ANSWER_URL}

xdg-open ${WSJ_URL}
xdg-open ${ANSWER_URL}

echo ${FILENAME}
echo
echo $(date --iso-8601)
echo
echo ${TITLE}
echo
echo ${DESCRIPTION}
echo
echo ${WSJ_URL}
echo ${ANSWER_URL}
