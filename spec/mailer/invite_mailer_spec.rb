require 'spec_helper'

RSpec.describe InviteMailer, type: :mailer do
  describe '#project_invite_email' do
    let(:project) { create :project }
    let(:inviter) { Faker::Name.name }
    let(:email)   { Faker::Internet.email }
    let(:is_new) { [true, false].sample }
    let(:data) do
      { project_name: project.name, email: email, inviter: inviter }
    end

    let!(:mail) { described_class.project_invite_email(data, is_new) }

    context 'when rendering header' do
      it { expect(mail.from).to eq(["no-reply@getarbor.io"]) }
      it { expect(mail.header[:from].value).to eq("Arbor <no-reply@getarbor.io>") }
      it { expect(mail.to).to eq([email]) }
      it { expect(mail.subject).to eq("You've been invited to an Arbor project!") }
    end
  end
end
