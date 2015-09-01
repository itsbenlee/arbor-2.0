class InviteMailer < ActionMailer::Base
  default from: ENV['FROM_EMAIL_ADDRESS']

  def project_invite_email(data, is_new)
    @project_name = data[:project_name]
    @inviter = data[:inviter]
    @is_new = is_new
    @link_url = root_url

    attachments.inline['logo.svg'] = File.read('public/arbor-logo.svg')

    mail to: data[:email], subject: t('mailer.invite.subject')
  end
end
