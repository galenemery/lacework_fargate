#!/bin/sh
# This script is copied into the above minimal datacollector sidecar image, for execution at runtime (using ENTRYPOINT) from customer image.

##### Lacework Access Token ####
# For lacework access token, either provide as an environment variable or hardcode into this script

# Option 1: Env var (this just validates it exists in ENV)
# if [ -z "$LW_CONFIG" ]; then
#   echo "Please set the LW_CONFIG environment variable to your Lacework JSON config in a single line string."
#   exit 1
# fi

# Option 2: Hardcoded
LW_CONFIG='
{
  "tokens": {
    "accesstoken": "#########"
  },
  "tags": {
    "tag1": "value1",
    "tag2": "value2"
  }
}'


#### Additional runtime setup steps #####
# Check for existence of CA Certs in customer image and embed if not present
if [ ! -f /etc/ssl/certs/ca-certificates.crt ]; then
  echo "Root certs not found, adding from /shared"
  mkdir -p /etc/ssl/certs
  cp /shared/ca-certificates.crt /etc/ssl/certs
fi

# Create lacework directories
mkdir -p /var/log/lacework /var/lib/lacework/config

# Copy correct binary
if grep -q Alpine /etc/issue; then
  echo "Using alpine datacollector"
  cp /shared/datacollector_alpine /var/lib/lacework/datacollector
else
  echo "Using linux datacollector"
  cp /shared/datacollector_linux /var/lib/lacework/datacollector
fi

chmod +x /var/lib/lacework/datacollector

# Create config file
echo $LW_CONFIG > /var/lib/lacework/config/config.json

# datacollector should log to stdout and not filesystem
ln -s /dev/stdout /var/log/lacework/datacollector.log

# Start datacollector
/var/lib/lacework/datacollector &
echo "Lacework datacollector started."

# Execute customer CMD
exec "$@"