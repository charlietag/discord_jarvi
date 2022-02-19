#!/bin/env ruby
require_relative '../libs/discord_jarvis.rb'

#-----------------------------
# Script lock
#-----------------------------
script = Filelock.new

#-----------------------------
# prepare files before start
#-----------------------------
jarvis_pid = Process.pid

puts "fork message.rb: #{jarvis_pid}"
File.open($newbie_pid,  "w")  {  |f|  f.write  jarvis_pid }

unless File.file?($newbie_answered)
  File.open($newbie_ans,       "w")  {  |f|  f.write  "a"        }
  File.open($newbie_fail,      "w")  {  |f|  f.write  "b c d"      }
  File.open($newbie_ans_msg,   "w")  {  |f|  f.write  "correct"  }
  File.open($newbie_fail_msg,  "w")  {  |f|  f.write  "error"    }
  File.open($newbie_answered,  "w")  {  |f|  f.write  "y"        }
end

newbie_ans      = File.read($newbie_ans)
newbie_fail     = File.read($newbie_fail).split(" ").join("|").gsub(/"/,'')
newbie_ans_msg  = File.read($newbie_ans_msg)
newbie_fail_msg = File.read($newbie_fail_msg)

newbie_answered = File.read($newbie_answered)


# show on console for debug
puts "#{newbie_fail}"
#-----------------------------
# Define message event
#-----------------------------
bot = Discordrb::Bot.new token: $bot_token

# ------------
# correct
# ------------
# bot.message(with_text: /[^(#{newbie_fail})]*(#{newbie_ans})+[^(#{newbie_fail})]*/i) do |event|
# same as
# bot.message(with_text: /[^#{newbie_fail}]*(#{newbie_ans})+[^#{newbie_fail}]*/i) do |event|

bot.message(with_text: /(?:(?!#{newbie_fail}).)*(#{newbie_ans})+(?:(?!#{newbie_fail}).)*/i) do |event|

  # ---------------------------------------------
  # show only when correct answer is not been chosen
  # ---------------------------------------------
  if newbie_answered != 'y'
    event.respond newbie_ans_msg


    # --- mark as answered, and reload the variable ---
    script.lock
    File.open($newbie_answered,"w")  {  |f|  f.write  "y"  }
    newbie_answered = File.read($newbie_answered)
    script.unlock

  end


end

# ------------
# correct
# ------------
bot.message(with_text: /(.*(#{newbie_fail})+.*){2,}/i) do |event|
  # ---------------------------------------------
  # show only when correct answer is not been chosen
  # ---------------------------------------------
  if newbie_answered != 'y'
    event.respond newbie_fail_msg
  end
end

bot.run
