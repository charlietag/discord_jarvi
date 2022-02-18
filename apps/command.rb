#!/bin/env ruby


require_relative '../libs/discord_jarvis.rb'


#-----------------------------
# Script lock
#-----------------------------
script = Filelock.new
# script.lock

# File.open($today_ans,       "w")  {  |f|  f.write  "a"        }
# File.open($today_fail,      "w")  {  |f|  f.write  "b c d"      }
# File.open($today_ans_msg,   "w")  {  |f|  f.write  "correct"  }
# File.open($today_fail_msg,  "w")  {  |f|  f.write  "error"    }
# File.open($today_answered,  "w")  {  |f|  f.write  "y"        }
#-----------------------------
# Script unlock
#-----------------------------
# script.unlock

# puts $today_ans
# puts $today_fail
# puts $today_ans_msg
# puts $today_fail_msg
# puts $today_answed
# exit

# -------- Command ------------
def print_help
  message = "--------------\n"
  message += %{ /set_ans "a b c d" "congras! the answer is a" "sorry, the answer is not in the options..."\n }
  message += %{ a(correct)\n  b(wrong)\n  c(wrong)\n  d(wrong)\n }
  message += %{ currect_msg: congras! the answer is a\n }
  message += %{ error_msg: sorry, the answer is not in the options...\n }
  message += "--------------\n"
end

# bot = Discordrb::Commands::CommandBot.new token: bot_token, prefix: '!'
bot = Discordrb::Commands::CommandBot.new token: $bot_token, prefix: '/'

# bot.command :user do |event|
#   event.user.name
# end

# bot.command :channel do |event|
#   event.channel.name
# end

bot.command :help do |event|
  if $command_channels.include? event.channel.name
    event.respond print_help
  end
end

bot.command :set_ans do |_event, *args|
  if $command_channels.include? _event.channel.name

    first_arr = args.join(" ").split('" "').first.gsub(/"/,'').split(" ").uniq
    second_msg = args.join(" ").split('" "').pop(2).first.gsub(/"/,'')
    third_msg = args.join(" ").split('" "').pop(2).pop.gsub(/"/,'')

    yes_option = first_arr.first
    no_options = first_arr - yes_option.split

    yes_msg = second_msg
    mess_msg = third_msg

    script.lock

    File.open($today_ans,       "w")  {  |f|  f.write  "#{yes_option}"       }
    File.open($today_fail,      "w")  {  |f|  f.write  "#{no_options.join("  ")}"  }
    File.open($today_ans_msg,   "w")  {  |f|  f.write  "#{yes_msg}"          }
    File.open($today_fail_msg,  "w")  {  |f|  f.write  "#{mess_msg}"         }
    File.open($today_answered,  "w")  {  |f|  f.write  "n"                   }

    script.unlock

    display_msg =  "ANS: #{yes_option}\n"
    display_msg += "Fail: #{no_options.join(" ")}\n"
    display_msg += "ANS Message: #{yes_msg}\n"
    display_msg += "Fails Message: #{mess_msg}\n"

    # _event.respond "#{_event.channel.name}: #{args.join(' ')}"
    _event.respond display_msg


    message_event = File.dirname(__FILE__) + "/message.rb"

    message_pid = File.read($today_pid)
    res = spawn("/usr/bin/kill  #{message_pid}")

    res = spawn("#{message_event}")

  end
end

bot.run
