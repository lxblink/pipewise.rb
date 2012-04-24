# pipewise.rb: Send user data to Pipewise from Ruby

pipewise.rb allows you to send user and event data to Pipewise via HTTP. You can use this gem to track user properties and lifecycle events.

## Installation

    $ gem install pipewise.rb

## Prerequisites

You must have a Pipewise account and an API key to use this gem. You can find your API key by logging into [pipewise.com](http://pipewise.com).

## Usage

To send data to Pipewise, you must first initialize the `Pipewise` module with your API key:

    # This could go in an initializer file
    Pipewise.config do |config|
      config.api_key = '04c66b8488569745e83c56b4c2774fcc6556add4'
    end

By default, all communication with api.pipewise.com occurs via HTTPS. If you prefer to use HTTP, set `protocol = 'http:'` in the initializer:

    Pipewise.config do |config|
      config.api_key = '04c66b8488569745e83c56b4c2774fcc6556add4'
      config.protocol = 'http:'
    end

With this object, you can send user or event details to Pipewise.

### Tracking Users

The `track_user` method will create a new user or update an existing one. The method requires the user's email address, and also takes an optional hash of custom and standard user properties.

    # Load a user of your app
    my_app_user = User.find(my_user_id)
    Pipewise.track_user(my_app_user.email, :created => my_app_user.created_at.to_i * 1000,
                        :subscription_type => 'premium')

If the call succeeds, `track_user` will return true. If there is a problem, an exception will be raised (more on this below).

### Tracking Events

To track a user lifecycle event, use `track_event`. This method requires the email address of the user you wish to tie the event to and the type of event that you are recording. It also accepts an optional hash of event properties.

    Pipewise.track_event('your-user@email.com', 'Purchased Goods', 
                         :purchase_category => 'clothing', :price => 99.95)

If the call succeeds, `track_event` will return true. If there is a problem, an exception will be raised. See the next section for more details on this.

### Tracking Purchases

The `track_purchase` method provides a convenient way to track a user's purchases. This method requires the email address of the user you wish to tie the purchase to and the amount of the purchase, which should be a numeric value. This method can also accept an optional hash of properties describing the purchase.

    Pipewise.track_purchase('your-user@email.com', 19.95)

Under the covers, this is just a convenience method that wraps a call to `track_event`.

### Exceptions

Unsuccessful calls to `track_user` and `track_event` will raise exceptions. The following exceptions are possible:

 * `Pipewise::InvalidApiKeyError` if the API key is invalid
 * `Pipewise::InvalidRequestError` if Pipewise could not process your request due to errors in the format of your request, such as an invalid email address. The exception message may contain more information on why the request failed.
 * `Pipewise::UnexpectedResponseError` if Pipewise could not process the response, possibly due to internal errors.

## Contributing to pipewise.rb
 
 * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
 * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
 * Fork the project.
 * Start a feature/bugfix branch.
 * Commit and push until you are happy with your contribution.
 * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
 * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Pipewise, Inc. See LICENSE for further details.
