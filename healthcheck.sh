#!/bin/bash
curl --include --no-buffer --header "Connection: Upgrade" --header "Upgrade: websocket" -vvv https://api-noor.senetlab.com:4443 || exit 1
