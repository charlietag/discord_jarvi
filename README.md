# Discord Jarvis

Try to build a discord bot using `ruby` and `gem: "discordrb"` (https://github.com/shardlab/discordrb)

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

**Scenario**

* Success
  * Match correct_option more than once, **no wrong_options** included
  * case insensitive
* Fail
  * Match wrong_options more than twice, even correct_option is included
* No response
  * Does not match correct_option
  * Only match wrong_options once

# Useful Regex Tools

Tester online

* [regexr.com](https://regexr.com/)
* [regex101.com](https://regex101.com/r/hgfjD5/1)

Regular Expression Visualizer

* [jex.im](https://jex.im/regulex/#!flags=&re=(%3F%3A(%3F!false%7Cnull).)*(true)%2B(%3F%3A(%3F!false%7Cnull).)*)
* [regexper.com](https://regexper.com/#%28%3F%3A%28%3F!false%7Cnull%29.%29*%28true%29%2B%28%3F%3A%28%3F!false%7Cnull%29.%29*)
