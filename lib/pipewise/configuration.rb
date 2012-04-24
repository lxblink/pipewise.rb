require 'pipewise/version'

module Pipewise
  module Configuration
    VALID_OPTIONS = [:api_key, :host, :protocol, :user_agent].freeze

    DEFAULT_API_KEY = nil
    DEFAULT_HOST = 'api.pipewise.com'.freeze
    DEFAULT_PROTOCOL = 'https:'.freeze
    DEFAULT_USER_AGENT = "Pipewise Ruby Gem v. #{Version::STRING}".freeze

    attr_accessor *VALID_OPTIONS

    # Allow initializers to set configuration options in a block
    def configure
      yield self
    end

    def reset
      self.api_key = DEFAULT_API_KEY
      self.host = DEFAULT_HOST
      self.protocol = DEFAULT_PROTOCOL
      self.user_agent = DEFAULT_USER_AGENT
      self
    end

    # Resets config options upon module extension
    def self.extended(base)
      base.reset
    end
  end
end
