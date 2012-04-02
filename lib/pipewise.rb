require 'net/http'
require 'json'
require 'pipewise/errors'

class Pipewise
  # Constructor takes the Pipewise API key (required), and optionally
  # takes a hash which allows you to specify :insecure => true
  # for use of HTTP instead of HTTPS. HTTPS is the default.
  def initialize(api_key, options = {})
    @api_key = api_key
    @host = options[:host] || 'api.pipewise.com'
    @protocol = options[:insecure] ? 'http:' : 'https:'
  end

  attr_reader :api_key, :host, :protocol

  # Sends user info to Pipewise for tracking the user identifed by the given email 
  # address (required), and supports an optional hash of properties for that user.
  # Pipewise will update the given user's properties each time this method is called
  # and will record a sighting event for this user, which updates the last active 
  # timestamp for this user. If you do NOT want Pipewise to record a sighting event
  # for this user, then add :pw_no_event => true to the property hash. Each call to
  # this method will make a blocking HTTP request.
  def track_user(email, user_properties = {})
    post_request('track', {:email => email}.merge(user_properties))
  end

  # Sends event info to Pipewise for the user identifed by the given email 
  # address (required) and records an event of the given type (required). This method 
  # also supports an optional hash of properties describing this event. A new event 
  # will be recorded every time this method is called, and the user's last active 
  # timestamp will be updated. Each call to this method will make a blocking HTTP request.
  def track_event(user_email, event_type, event_properties = {})
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
