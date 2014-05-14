#!/usr/bin/env bash

# Find all ids that are present in either the search index or the crawlstate, but not in the other.
# Pipe the output of this script to `pipedelete.sh` in order to actually delete these urls from the target index.

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
crawlstate=${3:-crawlstate-$2}

indexquery='{
  "query": {
    "match_all": {}
  },
  "size": 99999,
  "fields": [
    "_id"
  ]
}'

crawlstatequery='{
  "query": {
    "match_all": {}
  },
  "post_filter": {
    "terms": {
      "status": [
        "not-modified",
        "resolved",
        "pending"
      ]
    }
  },
  "size": 99999,
  "fields": [
    "_id"
  ]
}'

crawlstate_known=`ssh $1 "curl -s -XPOST 'localhost:9200/$crawlstate/_search' -d '$crawlstatequery'" | jq -r ".hits.hits[] | ._id" | sort`
index_known=`ssh $1 "curl -s -XPOST 'localhost:9200/$index/_search' -d '$indexquery'" | jq -r ".hits.hits[] | ._id" | sort`

comm -3 <(echo "$crawlstate_known") <(echo "$index_known")

