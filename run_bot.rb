require_relative 'bot/client'
require_relative 'bot/app'

client = Client.new
app = App.new(client.api)
client.listen { |input| app.call(input) }