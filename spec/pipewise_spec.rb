require 'spec_helper'
require 'pipewise'

describe Pipewise do
  use_vcr_cassette

  let(:pipewise) do
    Pipewise.configure do |c|
      c.api_key = '04c66b8488569745e83c56b4c2774fcc6556add4'
      c.host = 'localhost:3000'
      c.protocol = 'http:'
    end
  end

  let(:invalid_pipewise) do
    Pipewise.configure do |c|
      c.api_key = 'api123'
      c.host = 'localhost:3000'
      c.protocol = 'http:'
    end
  end

  let(:unconfigured_pipewise) { Pipewise.reset }

  let(:https_pipewise) do
    Pipewise.configure do |c|
      c.api_key = '63cc6efec3da9dc6c569071335456c85c048fa17'
      c.host = 'dev2.pipewise.com'
      c.protocol = 'https:'
      c.ca_file = '/opt/local/share/curl/curl-ca-bundle.crt'
    end
  end

  shared_examples_for 'invalid request' do
    it 'raises an InvalidRequestError' do
      expect { vcr_request }.to raise_error Pipewise::InvalidRequestError
    end

    describe 'InvalidRequestError' do
      subject do
        begin
          vcr_request
        rescue Pipewise::InvalidRequestError => e
          e
        end
      end

      its(:message) { should match expected_message }
    end
  end

  shared_examples_for 'no API key given' do
    it 'raises a InvalidApiKeyError' do
      expect {
        request_method
      }.to raise_error Pipewise::InvalidApiKeyError
    end

    describe 'InvalidApiKeyError' do
      subject do
        begin
          request_method
        rescue Pipewise::InvalidApiKeyError => e
          e
        end
      end

      its(:message) { should match /you must specify an api key/i }
    end
  end

  describe '.track_customer' do
    context 'with a valid email address' do
      shared_examples_for 'valid config' do
        it 'returns true' do
          subject.track_customer('valid@mail.com', {:created => Time.utc(2012, 5, 7, 23, 30),
                             :custom_property => 'Custom property value!'}).should be_true
        end
      end

      context 'with an http configuration' do
        subject { pipewise }
        it_behaves_like 'valid config'
      end

      context 'with an https configuration' do
        subject { https_pipewise }
        it_behaves_like 'valid config'
      end
    end

    context 'with an invalid API key' do
      it 'raises an InvalidApiKeyError' do
        expect {
          invalid_pipewise.track_customer('user@mail.com')
        }.to raise_error Pipewise::InvalidApiKeyError
      end
    end

    context 'with an invalid email address' do
      let(:vcr_request) { pipewise.track_customer('user.com') }
      let(:expected_message) { /email must be a valid email address/i }
      it_behaves_like 'invalid request'
    end

    context 'without an API key' do
      let(:request_method) { unconfigured_pipewise.track_customer('valid@mail.com') }
      it_behaves_like 'no API key given'
    end
  end

  describe '.track_event' do
    context 'with a valid email address and event type' do
      subject do
        pipewise.track_event('valid@mail.com', 'my_event_type',
                             {:custom_property => 'Custom property value!'})
      end

      it { should be_true }
    end

    context 'with an invalid API key' do
      it 'raises an InvalidApiKeyError' do
        expect {
          invalid_pipewise.track_event('event@mail.com', 'My Event Type')
        }.to raise_error Pipewise::InvalidApiKeyError
      end
    end

    context 'with an invalid email address' do
      let(:vcr_request) { pipewise.track_event('event.com', 'event_type') }
      let(:expected_message) { /valid email address is required/i }
      it_behaves_like 'invalid request'
    end

    context 'with a nil event type' do
      let(:vcr_request) { pipewise.track_event('mail@event.com', nil) }
      let(:expected_message) { /event type is required/i }
      it_behaves_like 'invalid request'
    end

    context 'without an API key' do
      let(:request_method) { unconfigured_pipewise.track_event('valid@mail.com', 'event_type') }
      it_behaves_like 'no API key given'
    end
  end

  describe '.track_purchase' do
    context 'with a valid email address and amount' do
      subject { pipewise.track_purchase('valid@mail.com', 39.95) }
      it { should be_true }
    end

    context 'with a nil an amount' do
      let(:vcr_request) { pipewise.track_purchase('valid@mail.com', nil) }
      let(:expected_message) { /amount cannot be nil/i }
      it_behaves_like 'invalid request'
    end

    context 'with a non-numeric amount' do
      it 'raises an ArgumentError' do
        expect {
          pipewise.track_purchase('valid@mail.com', 'NaN')
        }.to raise_error ArgumentError, 'amount must be a number'
      end
    end
  end
end
