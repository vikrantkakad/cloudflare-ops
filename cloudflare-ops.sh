#!/bin/bash
echo
if [ $# -ne 2 ]; then
	echo "Error: Invalid number of arguments"
	echo "Usage: cloudflare-ops.sh dev-mode <status / on / off>"
	echo "                        OR"
	echo "       cloudflare-ops.sh cache <clear / purge>"
	echo
 	exit 1
fi
CF_OPRN=$1
CF_VAL=$2

if [ -z "$CLOUDFLARE_ZONE_ID" ]; then
	echo 'Error: CLOUDFLARE_ZONE_ID is not set.'
	echo
	exit 1
fi

if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
        echo 'Error: CLOUDFLARE_API_TOKEN is Empty.'
        echo
        exit 1
fi

shopt -s nocasematch
if [ $CF_OPRN = 'dev-mode' ]; then
	if [ $CF_VAL = 'on' ]; then
		echo "Enabling CloudFlare Development Mode for next 3 hrs."
		curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/settings/development_mode" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type:application/json" --data '{"value":"on"}'
		echo;echo
		echo "CloudFlare Development Mode status: "
		curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/settings/development_mode" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json" | awk 'match($0,/"value":"[a-z]+/){print substr($0,RSTART+9,RLENGTH-9)}'

	elif [ $CF_VAL = 'off' ]; then
		echo "Disabling CloudFlare Development Mode."
		curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/settings/development_mode" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type:application/json" --data '{"value":"off"}'
		echo;echo
		echo "CloudFlare Development Mode status: "
		curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/settings/development_mode" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json" | awk 'match($0,/"value":"[a-z]+/){print substr($0,RSTART+9,RLENGTH-9)}'

	elif [ $CF_VAL = 'status' ]; then
		echo "CloudFlare Development Mode status: "
		curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/settings/development_mode" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json" | awk 'match($0,/"value":"[a-z]+/){print substr($0,RSTART+9,RLENGTH-9)}'

	else
		echo "Invalid dev-mode option. Valid options are <on / off>."
	fi

elif [ $CF_OPRN = 'cache' ]; then
	if [ $CF_VAL = 'clear' ]; then
		echo "Purging CloudFlare cache."
		curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type:application/json" --data '{"purge_everything":true}'

	elif [ $CF_VAL = 'purge' ]; then
		echo "Purging CloudFlare cache."
		curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type:application/json" --data '{"purge_everything":true}'

	else
		echo "Invalid cache option. Valid options are <clear / purge>."
	fi

else
	echo "Invalid operation. Valid ops are <dev-mode / cache>."
fi

shopt -u nocasematch
echo
