require 'yaml'
require 'discordrb'

require_relative 'filelock'

#-----------------------------
# Setup
#-----------------------------
config_file = File.dirname(__FILE__) + "/../config/config.yml"
configs = YAML.load_file(config_file)

$bot_token = configs['bot_token']
$activated_servers = configs['activated_servers']
$message_channels = configs['message_channels']
$command_channels = configs['command_channels']

$skip_commands = configs['skip_commands']


$command_use_pm_channel = configs['command_use_pm_channel']

#-----------------------------
# Setup Filenames
#-----------------------------
tmp_dir        = File.dirname(__FILE__) + "/../tmp"
# today_date     = Time.now.strftime("%Y-%m-%d")
prefix     = "newbie"

$newbie_ans      = "#{tmp_dir}/#{prefix}_ans.dat"
$newbie_fail     = "#{tmp_dir}/#{prefix}_fail.dat"
$newbie_ans_msg  = "#{tmp_dir}/#{prefix}_ans_msg.dat"
$newbie_fail_msg = "#{tmp_dir}/#{prefix}_fail_msg.dat"

$newbie_pid      = "#{tmp_dir}/#{prefix}_pid.dat"

$newbie_answered = "#{tmp_dir}/#{prefix}_answered.dat"

$owner_user = "#{tmp_dir}/#{prefix}_owner_user.dat"
