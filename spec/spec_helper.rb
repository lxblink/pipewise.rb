require 'rspec/core'
require 'rspec/expectations'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :fakeweb
end
