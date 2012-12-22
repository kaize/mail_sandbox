class MyObserver

  attr_reader :message

  def initialize
  end

  def update(message)
    @message = message
  end

end