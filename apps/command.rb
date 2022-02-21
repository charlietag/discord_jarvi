#!/bin/env ruby
require_relative '../libs/discord_jarvis.rb'


#-----------------------------
# Script lock
#-----------------------------
script = Filelock.new
# script.lock

#-----------------------------
# Script unlock
#-----------------------------
# script.unlock

#-----------------------------
# show help
#-----------------------------
# def print_help
#   message = "------------- Usage -------------\n"
#   message += %{ /set_ans "e a b c d"   "Correct MSG: Congras! the answer is e"   "Fail MSG: Sorry, you are just trying blind guess..."\n\n }
#   message += %{ e(correct)\n  a(wrong)\n  b(wrong)\n  c(wrong)\n  d(wrong)\n\n }
#   message += %{ Correct MSG: Congras! the answer is e\n }
#   message += %{ Fail MSG: Sorry, you are just trying blind guess...\n }
#   message += "--------------------------------\n"
#   message += %{ Activated Server: #{$activated_servers.join(" ")} \n }
#   message += %{ COMMAND Channel: #{$command_channels.join(" ")} \n }
#   message += %{ MESSAGE Channel: #{$message_channels.join(" ")} \n }
#   message += "--------------------------------\n"
#   message += %{ You are in :  \n }
#   message += %{ Server: #{event.server.name} \n }
#   message += %{ Channel: #{event.channel.name} \n }
#   message += "------------- Usage ------------\n"
# end

#-----------------------------
# define command
#-----------------------------
bot = Discordrb::Commands::CommandBot.new token: $bot_token, prefix: '/'

# ---------- Sample ---------
# bot.command :user do |event|
#   if $activated_servers.include? event.server.name
#     if $command_channels.include? event.channel.name
#       event.user.name
#     end
#   end
# end
#
# bot.command :channel do |event|
#   if $activated_servers.include? event.server.name
#     if $command_channels.include? event.channel.name
#       event.channel.name
#     end
#   end
# end
#
# bot.command :server do |event|
#   if $activated_servers.include? event.server.name
#     if $command_channels.include? event.channel.name
#       event.server.name
#     end
#   end
# end
# ---------- Sample ---------

# --- command: help ---
bot.command :help do |event|
  if $activated_servers.include? event.server.name
    if $command_channels.include? event.channel.name
      # event.respond print_help
      message = "------------- Usage -------------\n"
      message += %{ /set_ans "e a b c d"   "Correct MSG: Congras! the answer is e"   "Fail MSG: Sorry, you are just trying blind guess..."\n\n }
      message += %{ e(correct)\n  a(wrong)\n  b(wrong)\n  c(wrong)\n  d(wrong)\n\n }
      message += %{ Correct MSG: Congras! the answer is e\n }
      message += %{ Fail MSG: Sorry, you are just trying blind guess...\n }
      message += "--------------------------------\n"
      message += %{ Activated Server: #{$activated_servers.join(" ")} \n }
      message += %{ COMMAND Channel: #{$command_channels.join(" ")} \n }
      message += %{ MESSAGE Channel: #{$message_channels.join(" ")} \n }
      message += "--------------------------------\n"
      message += %{ You are in :  \n }
      message += %{ Server: #{event.server.name} \n }
      message += %{ Channel: #{event.channel.name} \n }
      message += "------------- Usage ------------\n"

      event.respond message

    end
  end
end

# --- command: set_ans ---
bot.command :set_ans do |_event, *args|
  if $activated_servers.include? _event.server.name
    if $command_channels.include? _event.channel.name

      # ----------------------------------------------------------
      # extract discord input
      # ----------------------------------------------------------
      first_arr = args.join(" ").split('" "').first.gsub(/"/,'').split(" ").uniq
      second_msg = args.join(" ").split('" "').pop(2).first.gsub(/"/,'')
      third_msg = args.join(" ").split('" "').pop(2).pop.gsub(/"/,'')

      yes_option = first_arr.first
      no_options = first_arr - yes_option.split

      yes_msg = second_msg
      mess_msg = third_msg

      # ----------------------------------------------------------
      # save extracted discord input
      # ----------------------------------------------------------
      script.lock

      File.open($newbie_ans,       "w")  {  |f|  f.write  "#{yes_option}"       }
      File.open($newbie_fail,      "w")  {  |f|  f.write  "#{no_options.join("  ")}"  }
      File.open($newbie_ans_msg,   "w")  {  |f|  f.write  "#{yes_msg}"          }
      File.open($newbie_fail_msg,  "w")  {  |f|  f.write  "#{mess_msg}"         }
      File.open($newbie_answered,  "w")  {  |f|  f.write  "n"                   }

      script.unlock

      # ----------------------------------------------------------
      # display extracted discord input
      # ----------------------------------------------------------
      display_msg =  "CORRECT OPTION: #{yes_option}\n"
      display_msg += "WRONG OPTIONS: #{no_options.join(" ")}\n\n"
      display_msg += "Correct Message: #{yes_msg}\n"
      display_msg += "Wrong Message: #{mess_msg}\n"

      # _event.respond "#{_event.channel.name}: #{args.join(' ')}"
      _event.respond display_msg


      # ----------------------------------------------------------
      # register messege event by forking message.rb
      # ----------------------------------------------------------
      message_event = File.dirname(__FILE__) + "/message.rb"

      if File.file?($newbie_pid)
        message_pid = File.read($newbie_pid)
        res = spawn("/usr/bin/kill  #{message_pid}")
      end

      res = spawn("#{message_event}")

    end
  end
end

# --- command: get_status ---
bot.command :get_status do |event|
  if $activated_servers.include? event.server.name
    if $command_channels.include? event.channel.name
      display_msg = "Nothing happened here..."

      if File.file?($newbie_answered)
        # ----------------------------------------------------------
        # Fetch info from dat files
        # ----------------------------------------------------------
        newbie_ans      = File.read($newbie_ans)
        newbie_fail     = File.read($newbie_fail)
        newbie_ans_msg  = File.read($newbie_ans_msg)
        newbie_fail_msg = File.read($newbie_fail_msg)

        newbie_answered = File.read($newbie_answered)

        # ----------------------------------------------------------
        # display extracted discord input
        # ----------------------------------------------------------
        display_msg =  "Correct Option: #{newbie_ans}\n"
        display_msg += "Wrong Options: #{newbie_fail}\n\n"
        display_msg += "Correct Message: #{newbie_ans_msg}\n"
        display_msg += "Wrong Message: #{newbie_fail_msg}\n\n"
        display_msg += "Answer is used: #{newbie_answered}\n"
      end

      event.respond display_msg
    end
  end
end

bot.run
