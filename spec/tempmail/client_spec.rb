require 'spec_helper'
require 'net/smtp'
require 'gmail'
require 'sendpulse/smtp'

describe TempMail::Client do
  context 'get available domains' do
    subject { described_class.new.available_domains }

    it { expect(subject).to be_a Array }
    it { expect(subject).to_not be_empty }
  end

  context 'check incoming emails (empty inbox)' do
    subject { described_class.new.incoming_emails('demo@example.com') }

    it { expect(subject).to be_a Array }
    it { expect(subject).to be_empty }
  end

  context 'check incoming emails' do
    let(:client_id) { ENV['CLIENT_ID'] }
    let(:client_secret) { ENV['CLIENT_SECRET'] }
    let(:message_subject) { 'test message' }
    let(:message) { 'This is a test message.' }
    let(:from_email) { ENV['FROM_EMAIL'] }
    let(:to_email) { email = described_class.new.available_domains; "test#{email[rand(0..email.count - 1)]}" }
    let(:email) {
      {
        html: "<html><body><h1>#{message}</h1></body></html>",
        text: message,
        subject: message_subject,
        from: {
          name: "Sender name",
          email: from_email
        },
        to: [
          {
            name: "Receiver name",
            email: to_email
          }
        ]
      }
    }

    before do
      sendpulse = SendPulse::Smtp.new(client_id, client_secret, 'https', nil)
      sendpulse.send_email(email)
    end

    subject { described_class.new.incoming_emails(to_email) }

    it do
      expect(subject).to be_a Array
      expect(subject).to_not be_empty
      expect(subject.last).to include(:createdAt, :mail_id, :mail_address_id, :mail_from, :mail_subject, :mail_preview, :mail_text_only, :mail_text, :mail_html, :mail_timestamp, :_id)      
      expect(subject.last).to include(mail_address_id: Digest::MD5.hexdigest(to_email))
      expect(subject.last).to include(mail_from: "Sender name <#{from_email}>")
      expect(subject.last).to include(mail_subject: message_subject)
      expect(subject.last).to include(mail_text: message + ?\n)
    end
  end
end
