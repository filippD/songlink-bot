require_relative '../response'
require_relative '../command'

module Commands
  class Thanks < Command
    def responses
      [
        Response.new(
          :send_message,
          {
            text: 'Пожалуйста, брат',
            chat_id: input.chat.id
          }
        )
      ]
    end
  end
end
