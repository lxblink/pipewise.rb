require 'net/http'
require 'net/https'
require 'json'
require 'pipewise/errors'
require 'pipewise/configuration'

module Pipewise
  extend Configuration
  extend self

  # Sends user info to Pipewise for tracking the user identifed by the given email
  # address (required), and supports an optional hash of properties for that user.
  #
  # Pipewise will update the given user's properties each time this method is called
  # and will record a sighting event for this user, which updates the last active
  # timestamp for this user. If you do NOT want Pipewise to record a sighting event
  # for this user, then add :pw_no_event => true to the property hash. Each call to
  # this method will make a blocking HTTP request.
  #
  # :created (optional) - If you want to specify the time you first encountered this
  # customer set :created to a valid Time instance. If omitted, it will be set to the
  # current time by the Pipewise server.
  def track_customer(email, customer_properties = {})
    post_request('track', {:email => email}.merge(
        customer_properties.has_key?(:created) ?
          customer_properties.merge(:created => customer_properties[:created].to_i * 1000) :
          customer_properties))
  end
  
  #Old method
  def track_user(email, user_properties = {})
    self.track_customer(email, user_properties)
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
    socket = Net::HTTP.new(uri.host, uri.port)
    if protocol.downcase == 'https:'
      socket.use_ssl = true
      socket.ssl_version = :TLSv1
      if ca_file || ca_path
        socket.verify_mode = OpenSSL::SSL::VERIFY_PEER
        socket.ca_path = ca_path if ca_path
        socket.ca_file = ca_file if ca_file
      end
    end
    socket.start { |http| http.request(req) }
  end
  private :post_form
end
