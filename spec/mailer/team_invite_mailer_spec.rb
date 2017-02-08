require 'spec_helper'

RSpec.describe TeamInviteMailer, type: :mailer do
  describe '#team_invite_email' do
    let(:team)  { create :team }
    let(:email) { Faker::Internet.email }
    let(:data)  { { team_name: team.name, email: email } }
    let!(:mail) { described_class.team_invite_email(data) }

    context 'when rendering headers' do
      it { expect(mail.from).to eq(["no-reply@getarbor.io"]) }
      it { expect(mail.header[:from].value).to eq("Arbor <no-reply@getarbor.io>") }
      it { expect(mail.to).to eq([email]) }
      it { expect(mail.subject).to eq("You've been invited to an Arbor project!") }
    end
  end
end
