# cloudflare-ops
Bash script to access CloudFlare API for Dev-Mode &amp; Cache Purge

## Pre-requisite: ##

Generate CloudFlare custom API token for your Zone with below permissions: https://developers.cloudflare.com/api/tokens/create
* Cache Purge
* Development Mode

## Usage: ##

Toggle CloudFlare Development Mode for Zone:
```cloudflare-ops.sh dev-mode <status / on / off> ```

Purge CloudFlare Cache for Zone:
```cloudflare-ops.sh cache <clear / purge>```


