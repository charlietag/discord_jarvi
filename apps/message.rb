#!/bin/env ruby


require_relative '../libs/discord_jarvis.rb'
script = Filelock.new

unless File.file?($today_answered)
  File.open($today_ans,       "w")  {  |f|  f.write  "a"        }
  File.open($today_fail,      "w")  {  |f|  f.write  "b c d"      }
  File.open($today_ans_msg,   "w")  {  |f|  f.write  "correct"  }
  File.open($today_fail_msg,  "w")  {  |f|  f.write  "error"    }
  File.open($today_answered,  "w")  {  |f|  f.write  "y"        }
end
jarvis_pid = Process.pid
File.open($today_pid,  "w")  {  |f|  f.write  jarvis_pid }
# today_ans      = ""
# today_fail     = ""
# today_ans_msg  = ""
# today_fail_msg = ""
#
# today_answered = ""
#
# def source_files
#   today_ans      = File.read($today_ans)
#   today_fail     = File.read($today_fail).split(" ").join
#   today_ans_msg  = File.read($today_ans_msg)
#   today_fail_msg = File.read($today_fail_msg)
#
#   today_answered = File.read($today_answered)
#
# end
#
# source_files
  today_ans      = File.read($today_ans)
  today_fail     = File.read($today_fail).split(" ").join("|").gsub(/"/,'')
  today_ans_msg  = File.read($today_ans_msg)
  today_fail_msg = File.read($today_fail_msg)

  today_answered = File.read($today_answered)
# puts today_fail.split(" ").join
# exit


# -------- Content match ------------
bot = Discordrb::Bot.new token: $bot_token

bot.message(with_text: /[^(#{today_fail})]*(#{today_ans})+[^(#{today_fail})]*/i) do |event|
  # source_files
  if today_answered != 'y'
    event.respond today_ans_msg


    script.lock
    File.open($today_answered,"w")  {  |f|  f.write  "y"  }
    today_answered = File.read($today_answered)
    script.unlock

  end


end
p "#{today_fail}"
bot.message(with_text: /(#{today_fail}| ){2,}/i) do |event|
  # source_files
  if today_answered != 'y'
    event.respond today_fail_msg
  end
end

bot.run
