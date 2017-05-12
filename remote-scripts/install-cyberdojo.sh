#/bin/bash
set -e

curl -O https://raw.githubusercontent.com/cyber-dojo/commander/master/cyber-dojo
chmod +x cyber-dojo
sudo ./cyber-dojo up
