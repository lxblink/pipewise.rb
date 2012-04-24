require 'net/http'
require 'json'
require 'pipewise/errors'
require 'pipewise/configuration'

module Pipewise
  extend Configuration
  extend self

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

  # Convenience method for reporting purchase events to Pipewise. Internally this method
  # calls track event, specifying the given amount as the purchase amount
  def track_purchase(user_email, amount, purchase_event_properties = {})
    raise InvalidRequestError.new("amount cannot be nil for purchase events") unless amount
    raise ArgumentError.new("amount must be a number") unless amount.to_s =~ /\A[+-]?\d*(\.\d+)?\Z/
    track_event(user_email, 'purchase', purchase_event_properties.merge(:amount => amount))
  end

  def post_request(path, params)
    raise InvalidApiKeyError.new("You must specify an API key") unless api_key
    uri = URI("#{protocol}//#{host}/apps/#{api_key}/#{path}")
    response = post_form(uri, params)
    return true if response.code.start_with? '2'
    case response.code
    when '404'
      raise InvalidApiKeyError.new("#{api_key} is not a valid Pipewise API key")
    when '422'
      error_str = (response.content_type =~ /json/ && response.body !~ /\A\s*\Z/)? 
        ": \n#{JSON.parse(response.body)['errors'].join('\n')}" : ''
      raise InvalidRequestError.new("Error from Pipewise API: Invalid request#{error_str}")
    end
  end
  private :post_request

  def post_form(uri, params)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.form_data = params
    req['User-Agent'] = user_agent
    Net::HTTP.new(uri.host, uri.port).start do |http|
      http.request(req)
    end
  end
  private :post_form
end
