require_relative '../response'
require_relative '../command'

module Commands
  class Default < Command
    def responses
      [
        Response.new(
          :send_message,
          {
            text: 'Fuck off, I am still in development',
            chat_id: input.chat.id
          }
        )
      ]
    end
  end
end
