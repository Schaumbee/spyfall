#!/bin/bash

set -e

echo -n "Enter your Slack bot API token: "
read token

echo -n "Enter the channel that will be used for the game: [#]"
read channel

cp spyfall/config/secret.exs.sample spyfall/config/secret.exs

sed -i '' "s/{{SLACK_TOKEN}}/$token/g" spyfall/config/secret.exs
sed -i '' "s/{{SLACK_CHANNEL}}/$channel/g" spyfall/config/secret.exs

echo "Configuration set."
