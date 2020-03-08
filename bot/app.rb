require_relative 'router'

class App
  def initialize(api)
    @api = api
  end

  def call(input)
    command = Router.new.call(input)
    command.execute
    command.responses.each { |r| api.public_send(r.method, r.params) }
  end

  private

  attr_reader :api
end
