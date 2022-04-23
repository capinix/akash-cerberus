#!/bin/bash

# set the path for the df command to the root "/" if none is
# given on the command line
SEARCH_PATH=${1:-/}

# run the diskfree command
df -h $SEARCH_PATH

echo

printf "%19s %11s %15s\n" "latest_block_height" "catching_up" "voting_power"

curl -s 'http://127.0.0.1:26657/status' | \
	jq -r '{
		h: .result.sync_info.latest_block_height, 
		c: .result.sync_info.catching_up, 
		v: .result.validator_info.voting_power
	}|.[]' | \
	LC_ALL=en_US.UTF-8 awk 'BEGIN {
	RS="";
	FS="\n"
	} {
		printf "%19\47d %11s %15\47d\n",$1,$2,$3
	}' 
