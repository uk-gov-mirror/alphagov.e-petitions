require 'rails_helper'
require_relative 'shared_examples'

RSpec.describe DeliverPetitionEmailJob, type: :job do
  let(:requested_at) { Time.current.change(usec: 0) }
  let(:requested_at_as_string) { requested_at.getutc.iso8601(6) }

  let(:petition) { FactoryGirl.create(:debated_petition) }
  let(:signature) { FactoryGirl.create(:validated_signature, petition: petition) }
  let(:email) { FactoryGirl.create(:petition_email, petition: petition) }
  let(:timestamp_name) { 'petition_email' }

  let :arguments do
    {
      signature: signature,
      timestamp_name: timestamp_name,
      petition: petition,
      requested_at: requested_at_as_string,
      email: email
    }
  end

  before do
    petition.set_email_requested_at_for(timestamp_name, to: requested_at)
  end

  it_behaves_like "a job to send an signatory email"

  it "uses the correct mailer method to generate the email" do
    expect(subject).to receive_message_chain(:mailer, :email_signer).with(petition, signature, email).and_return double.as_null_object
    subject.perform(**arguments)
  end
end
