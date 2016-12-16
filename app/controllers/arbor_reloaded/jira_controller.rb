module ArborReloaded
  class JiraController < ApplicationController
    def authenticate
      puts '*' * 100
      head :ok
    end
  end
end
