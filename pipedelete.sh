#!/usr/bin/env bash

# reads urls from stdin and deletes them from a target index through the pipeline.

if [ -z "$1" ]
then
  echo "Provide hostname or ip of elasticsearch"
  exit 1
fi
hostname=$1
if [ -z "$2" ]
then
  echo "Provide search index name or alias"
  exit 1
fi
index=$2

# https://gist.github.com/cdown/1163649
urlencode() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf + ;;
            *) printf '%%%X' "'$c"
        esac
    done
}

while read line; do
    ssh -n $1 "curl -s -XDELETE localhost:3000/$index/content/$(urlencode $line) && echo deleted $line"
done;
