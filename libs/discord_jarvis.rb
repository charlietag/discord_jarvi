require 'yaml'
require 'discordrb'

require_relative 'filelock'

#-----------------------------
# Setup
#-----------------------------
config_file = File.dirname(__FILE__) + "/../config/config.yml"
configs = YAML.load_file(config_file)

$bot_token = configs['bot_token']
$message_channels = configs['message_channels']
$command_channels = configs['command_channels']

#-----------------------------
# Setup Filenames
#-----------------------------
tmp_dir        = File.dirname(__FILE__) + "/../tmp"
# today_date     = Time.now.strftime("%Y-%m-%d")
today_date     = "newbie"

$today_ans      = "#{tmp_dir}/#{today_date}_ans.dat"
$today_fail     = "#{tmp_dir}/#{today_date}_fail.dat"
$today_ans_msg  = "#{tmp_dir}/#{today_date}_ans_msg.dat"
$today_fail_msg = "#{tmp_dir}/#{today_date}_fail_msg.dat"

$today_pid = "#{tmp_dir}/#{today_date}_pid.dat"

$today_answered   = "#{tmp_dir}/#{today_date}_answered.dat"
