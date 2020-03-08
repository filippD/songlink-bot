class Command
  def initialize(input)
    @input = input
  end

  def execute
  end

  def responses
    []
  end

  private

  attr_reader :input
end