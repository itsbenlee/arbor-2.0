class BaseMailer < ActionMailer::Base
  default from: "#{ENV['FROM_EMAIL_NAME']} <#{ENV['FROM_EMAIL_ADDRESS']}>"
end
