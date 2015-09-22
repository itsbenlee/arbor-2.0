class CommonResponse
  attr_accessor :success, :errors, :data

  def initialize(success, errors = [], data = {})
    @success = success
    @errors = errors
    @data = data
  end
end
