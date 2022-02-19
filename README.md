# Discord Jarvis

Try to build a discord bot using `ruby`

# Environment

Wherever you have `ruby` installed

# Register for discord API

Apply for an `APPLICATION ID` and a `BOT TOKEN`

* DEV URL
  * https://discord.com/developers

* Bot Permissions
  * only read / send messages permission
    * 3072

After you get your `APPLICATION ID` and `BOT TOKEN`, you can invite the discord bot via the following link

* Invite URL

  ```bash
  https://discord.com/oauth2/authorize?client_id={application-id}&scope=bot&permissions={bot-permissions}
  ```

* Invite URL - Sample

  ```bash
  https://discord.com/oauth2/authorize?client_id=999999999999999999&scope=bot&permissions=3072
  ```

# Usage

## Install

Clone this repo

```bash
$ git clone https://github.com/shardlab/discordrb.git
```

Install required ruby gem `discordrb`

```bash
$ bundle
```

Setup the config

```bash
$ vim config/config.yml

#API token
bot_token: 999999999999999999

# restrictions
message_channels: [ 'message_autoreply_channel_name', 'command_setting_channel_name' ]
command_channels: [ 'command_setting_channel_name' ]
```

Run the discord bot

```bash
$ ./start.sh
```

## Command

Type commands in discord chat channel. And only 3 commands here

`/help`       - show the help
`/set_ans`    - Setup and register the message event
`/get_status` - Get the setting and using status


**Usage of `/set_ans`**

```bash
/set_ans "e a b c d" "Correct MSG: Congras! the answer is e" "Fail MSG: Sorry, you are trying blind guess..."
```
