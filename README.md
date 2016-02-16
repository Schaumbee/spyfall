# Spyfall

A spyfall integration written for Slack. Instructions and commands for how to play
the game can be found by issuing `help` in the designated spyfall room.

## Usage

First, you will need to configure the app with your bot's Slack token. The setup
script will walk you through setup interactively.

```sh
script/setup.sh
```

NOTE: The room that is provided must already exist within your Slack org.

## Development

Development can be done in the Vagrant box, which will be provisioned automatically
as an Ubuntu machine with Elixir installed.

```sh
vagrant up
```

Once the box has been provisioned, ssh into the machine and install Mix dependencies

```sh
vagrant ssh

cd /vagrant/spyfall
mix deps.get
```

Finally, run the bot using

```sh
mix run --no-halt
```

To run in production, set `MIX_ENV=prod` and then compile

```sh
MIX_ENV=prod mix compile
MIX_ENV=prod mix run --no-halt
```
