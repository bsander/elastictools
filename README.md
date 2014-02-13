# Elastic tools

## Installation
`npm install`

## Tools
### Recreate
Deletes and recreates an index according to a given index spec.

`./recreate index-name index-configfile`

### Reindex
Performs a scan/scroll query on one index and bulk inserts all data into another.

`./reindex -i source-index-name -o dest-index-name [-h host:port]`

### Parsesynonyms
Parse a delivered synonym list with capitals and special characters with ElasticSearch to a normalized synonym list. By parsing it with elasticsearch we can be sure special characters will be converted like elasticsearch parses strings.

Requires JQ (http://stedolan.github.io/jq/) to be installed on your machine

`./parsesynonyms path-to-source-file [path-to-dest-file]`
