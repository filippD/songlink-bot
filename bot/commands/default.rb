require_relative '../response'

module Commands
  class Default
    def initialize(input)
      @input = input
    end

    def execute
    end

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

    private

    attr_reader :input
  end
end
