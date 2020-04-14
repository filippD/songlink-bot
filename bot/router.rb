require_relative 'commands/default.rb'
require_relative 'commands/null.rb'
require_relative 'commands/send_song_links.rb'
require_relative 'commands/thanks.rb'

class Router
  def call(input)
    command(input).new(input)
  end

  private

  def command(input)
    regex = Regexp.new(
      'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)'
    )
    case input.chat.type
    when 'private'
      if input.text&.match(regex)
        Commands::SendSongLinks
      else 
        Commands::Default
      end
    when 'supergroup', 'group'
      if input.text&.match(regex)
        Commands::SendSongLinks
      end
    end || Commands::Null
  end
end
