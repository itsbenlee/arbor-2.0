class CommonResponse
  attr_accessor :success, :errors, :data

  def initialize(success, errors = [], data = {})
    @success = success
    @errors = errors
    @data = data
  end

  def work
    yield
    self
  rescue StandardError => error
    @errors.push(error.message)
    self
  end
end
