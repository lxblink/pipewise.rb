require 'net/http'
require 'json'
require 'pipewise/errors'

class Pipewise
  def initialize(api_key, options = {})
    @api_key = api_key
    @host = options[:host] || 'api.pipewise.com'
    @protocol = options[:insecure] ? 'http:' : 'https:'
  end

  attr_reader :api_key, :host, :protocol

  def user(email, user_properties = {})
    post_request('track', {:email => email}.merge(user_properties))
  end

  def event(user_email, event_type, event_properties = {})
    post_request('track_event', {:email => user_email, :type => event_type}.merge(event_properties))
  end

  def post_request(path, params)
    uri = URI("#{protocol}//#{host}/apps/#{api_key}/#{path}")
    response = Net::HTTP.post_form(uri, params)
    return true if response.code.start_with? '2'
    case response.code
    when '404'
      raise InvalidApiKeyError.new("#{@api_key} is not a valid Pipewise API key")
    when '422'
      error_str = (response.content_type =~ /json/ && response.body !~ /\A\s*\Z/)? 
        ": \n#{JSON.parse(response.body)['errors'].join('\n')}" : ''
      raise InvalidRequestError.new("Error from Pipewise API: Invalid request#{error_str}")
    end
  end
  private :post_request
end

