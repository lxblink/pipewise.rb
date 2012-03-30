require 'spec_helper'
require 'pipewise'

describe Pipewise do
  let(:init_options) { {host: 'localhost:3000', insecure: true} }
  let(:pipewise) { Pipewise.new('04c66b8488569745e83c56b4c2774fcc6556add4', init_options) }
  let(:invalid_pipewise) { Pipewise.new('api123', init_options) }

  describe '#user' do
    context 'with a valid email address' do
      subject do
        VCR.use_cassette 'valid email for user' do
          pipewise.track_user('valid@mail.com', {:created => Time.now.to_i * 1000, 
                                           :custom_property => 'Custom property value!'})
        end
      end

      it { should be_true }
    end

    context 'with an invalid API key' do
      it 'raises an InvalidApiKeyError' do
        expect {
          VCR.use_cassette 'invalid api key for user' do
            invalid_pipewise.track_user('user@mail.com')
          end
        }.to raise_error Pipewise::InvalidApiKeyError
      end
    end

    context 'with an invalid email address' do
      let(:vcr_request) do
        VCR.use_cassette 'invalid email for user' do
          pipewise.track_user('user.com')
        end
      end

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

        its(:message) { should match /email must be a valid email address/i }
      end
    end
  end

  describe '#event' do
    context 'with a valid email address and event type' do
      subject do
        VCR.use_cassette 'valid arguments for user' do
          pipewise.track_event('valid@mail.com', 'my_event_type', 
                         {:custom_property => 'Custom property value!'})
        end
      end

      it { should be_true }
    end

    context 'with an invalid API key' do
      it 'raises an InvalidApiKeyError' do
        expect {
          VCR.use_cassette 'invalid api key for event' do
            invalid_pipewise.track_event('event@mail.com', 'My Event Type')
          end
        }.to raise_error Pipewise::InvalidApiKeyError
      end
    end

    context 'with an invalid email address' do
      let(:vcr_request) do
        VCR.use_cassette 'invalid email for event' do
          pipewise.track_event('event.com', 'event_type')
        end
      end

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

        its(:message) { should match /valid email address is required/i }
      end
    end

    context 'with a nil event type' do
      let(:vcr_request) do
        VCR.use_cassette 'nil event type' do
          pipewise.track_event('mail@event.com', nil)
        end
      end

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

        its(:message) { should match /event type is required/i }
      end
    end
  end
end
