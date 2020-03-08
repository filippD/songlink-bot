require_relative 'commands/default.rb'

class Router
  def call(input)
    command(input).new(input)
  end

  private

  def command(input)
    case input.text
    when 'test'
      Commands::Default
    end || Commands::Default
  end
end
