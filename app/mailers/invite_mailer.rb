class InviteMailer < ActionMailer::Base
  default from: ENV['FROM_EMAIL_ADDRESS']

  def project_invite_email(data, is_new)
    @project_name = data[:project_name]
    @inviter = data[:inviter]
    @is_new = is_new

    attachments.inline['logo.png'] = File.read(
      File.join Rails.root, 'public', 'arbor-logo.png'
    )

    mail to: data[:email], subject: t('mailer.invite.subject')
  end
end
