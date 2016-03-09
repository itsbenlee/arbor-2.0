class WellKnownController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render text: ENV['LETS_ENCRYPT_TEXT']
  end
end
