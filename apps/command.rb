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
# define command
#-----------------------------
bot = Discordrb::Commands::CommandBot.new token: $bot_token, prefix: '/'

# ---------- Sample ---------
# event.user.name
# event.channel.name
# event.server.name
# ---------- Sample ---------

# --- command: help ---
bot.command :help do |event|
  pm_channel_name = defined?(event.user.channel.name) ? event.user.channel.name : nil
  server_name = defined?(event.server.name) ? event.server.name : nil
  channel_name = defined?(event.channel.name) ? event.channel.name : nil

  if ($activated_servers.include? server_name and $command_channels.include? channel_name) or (! pm_channel_name.nil? and $command_use_pm_channel == 'y')
    # event.respond print_help
    message = "-----------------------------------------\n"
    message += "              Usage \n"
    message += "-----------------------------------------\n"
    message += %{ /set_ans "e a b c d"   "Correct MSG: Congras! the answer is e"   "Fail MSG: Sorry, you are just trying blind guess..."\n\n }
    message += %{ e(correct)\n  a(wrong)\n  b(wrong)\n  c(wrong)\n  d(wrong)\n\n }
    message += %{ Correct MSG: Congras! the answer is e\n }
    message += %{ Fail MSG: Sorry, you are just trying blind guess...\n }
    message += "\n"
    message += "-----------------------------------------\n"
    message += "              Info \n"
    message += "-----------------------------------------\n"
    message += %{ Activated Server: #{$activated_servers.join(" ")} \n }
    message += %{ COMMAND Channel: #{$command_channels.join(" ")} \n }
    message += %{ MESSAGE Channel: #{$message_channels.join(" ")} \n }
    message += "\n"
    message += %{ You are in :  \n }
    message += %{ Server: #{server_name} \n }
    message += %{ Channel: #{channel_name if pm_channel_name.nil?} \n }
    message += %{ Private Channel: #{pm_channel_name.nil? ? 'n' : 'y'} \n }
    message += "\n"
    message += "-----------------------------------------\n"
    message += "             Commands \n"
    message += "-----------------------------------------\n"
    message += "/set_ans\n"
    message += "/get_status\n"
    message += "/help\n"
    message += "/clear\n"
    message += "-----------------------------------------\n"

    event.respond message

  end
end

# --- command: set_ans ---
bot.command :set_ans do |_event, *args|
  pm_channel_name = defined?(_event.user.channel.name) ? _event.user.channel.name : nil
  server_name = defined?(_event.server.name) ? _event.server.name : nil
  channel_name = defined?(_event.channel.name) ? _event.channel.name : nil

  if ($activated_servers.include? server_name and $command_channels.include? channel_name) or (! pm_channel_name.nil? and $command_use_pm_channel == 'y')

    owner_user = File.file?($owner_user) ? File.read($owner_user) : nil
    newbie_answered = File.file?($newbie_answered) ? File.read($newbie_answered) : nil

    if newbie_answered == 'y' or newbie_answered.nil?
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
      File.open($newbie_answered,  "w")  {  |f|  f.write  "n"  }
      File.open($owner_user,       "w")  {  |f|  f.write  "#{_event.user.name}"   }

      script.unlock

      # ----------------------------------------------------------
      # display extracted discord input
      # ----------------------------------------------------------
      display_msg =  "CORRECT OPTION: #{yes_option}\n"
      display_msg += "WRONG OPTIONS: #{no_options.join(" ")}\n\n"
      display_msg += "Correct Message: #{yes_msg}\n"
      display_msg += "Wrong Message: #{mess_msg}\n"

      # _event.respond "#{_event.channel.name}: #{args.join(' ')}"

      # ----------------------------------------------------------
      # register messege event by forking message.rb
      # ----------------------------------------------------------
      # message_event = File.dirname(__FILE__) + "/message.rb"
      #
      # if File.file?($newbie_pid)
      #   message_pid = File.read($newbie_pid)
      #   res = spawn("/usr/bin/kill  #{message_pid}")
      # end
      #
      # res = spawn("#{message_event}")

      # ---------------------------------------------------------
    else
      display_msg = "The quiz is set by @#{owner_user}.   And it is not finished yet.\n"
      display_msg += "Or you can force to /clear this quiz! And set your own quiz!\n"
    end

    _event.respond display_msg
  end

end

# --- command: get_status ---
bot.command :get_status do |event|
  pm_channel_name = defined?(event.user.channel.name) ? event.user.channel.name : nil
  server_name = defined?(event.server.name) ? event.server.name : nil
  channel_name = defined?(event.channel.name) ? event.channel.name : nil

  if ($activated_servers.include? server_name and $command_channels.include? channel_name) or (! pm_channel_name.nil? and $command_use_pm_channel == 'y')
    display_msg = nil

    owner_user = File.file?($owner_user) ? File.read($owner_user) : nil

    if owner_user == event.user.name
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

    else

      newbie_answered = File.file?($newbie_answered) ? File.read($newbie_answered) : nil

      if newbie_answered == 'y'
        display_msg = "Try /set_ans to start a new quiz! (for full usage /help)"
      else
        display_msg = "You should ask @#{owner_user} for the answer"

      end

    end


    event.respond display_msg
  end
end


# --- command: clear ---
bot.command :clear do |event|
  pm_channel_name = defined?(event.user.channel.name) ? event.user.channel.name : nil
  server_name = defined?(event.server.name) ? event.server.name : nil
  channel_name = defined?(event.channel.name) ? event.channel.name : nil

  if ($activated_servers.include? server_name and $command_channels.include? channel_name) or (! pm_channel_name.nil? and $command_use_pm_channel == 'y')

    File.open($newbie_answered,  "w")  {  |f|  f.write  "y"  }
    event.respond "all clear!! You can setup a new answer now!"
  end
end


bot.run
