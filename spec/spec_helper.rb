require 'rspec/core'
require 'rspec/expectations'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :fakeweb
  config.default_cassette_options = {:match_requests_on => [:method, :uri, :body],
                                     :record => :new_episodes}
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
