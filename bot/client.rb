require 'dotenv/load'
require 'telegram/bot'

class Client
  attr_reader :api

  def initialize
    @client = Telegram::Bot::Client.new(ENV['BOT_TOKEN'])
    @api = client.api
    @logger = Logger.new("#{File.dirname(__FILE__)}/../log/bot.log")
  end

  def listen
    client.listen do |input|
      logger.info(input)

      begin
        yield(input)
      rescue Telegram::Bot::Exceptions::ResponseError => e
        logger.error(e.message)
      end
    end
  end

  def send_message(message, channel_id)
    api.send_message(
      chat_id: channel_id,
      text: message,
      parse_mode: 'Markdown',
      disable_web_page_preview: true
    )
  end

  private

  attr_reader :client, :logger
end
