require_relative 'commands/default.rb'
require_relative 'commands/null.rb'
require_relative 'commands/send_song_links.rb'

class Router
  URL_REGEX = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.
    [a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)/x

  def call(input)
    command(input).new(input)
  end

  private

  def command(input)
    return Commands::Null unless input

    case input.chat.type
    when 'private'
      if input.text&.match(URL_REGEX)
        Commands::SendSongLinks
      else 
        Commands::Default
      end
    when 'supergroup', 'group'
      if input.text&.match(URL_REGEX)
        Commands::SendSongLinks
      end
    end || Commands::Null
  end
end
