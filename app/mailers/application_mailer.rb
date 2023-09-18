class ApplicationMailer < ActionMailer::Base
  default from: ENV["SENDGRID_SENDER"]
  layout 'mailer'
end
