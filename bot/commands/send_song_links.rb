require 'json'
require_relative '../response'
require_relative '../command'

module Commands
  class SendSongLinks < Command
    def execute
      regex = Regexp.new(
        'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)'
      )
      links = input.text.gsub(regex)
      song_link_api_url = 'https://api.song.link/v1-alpha.1/links?url='
      @links_by_platforms = links.map do |link|
          response = Faraday.get("#{song_link_api_url}#{link}")
          if response.status == 200
            body = JSON.parse(response.body)
            body['linksByPlatform']
          end
      end.compact
    end

    def responses
      links_by_platforms.map do |platform_link|
        Response.new(
          :send_message,
            {
              text: 'На нахуй',
              chat_id: input.chat.id,
              reply_markup: markup(platform_link)
            }
        )
      end
    end

    private

    attr_reader :links_by_platforms

    def markup(platforms)
      required_platforms = {
        appleMusic: true,
        youtubeMusic: true,
        soundcloud: true,
        youtube: true
      }
      keyboard = platforms.map do |platform, url|
        if required_platforms[platform.to_sym]
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: platform,
            url: url['url']
          )
        end
      end

      Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
    end
  end
end
