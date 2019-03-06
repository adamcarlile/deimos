# Deimos

Deimos is an application designed to be run alongside Phobos, but can be run in any context to provide a unified status and metrics interface for kubernetes style applications.

## Name

Deimos, brother of Phobos, from Greek mythology. The personification of dread and terror. Also it is the other natural Martian satelite, the first being Phobos

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deimos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deimos

## Usage

After the application is configured (see below), you can boot it by calling the following. Place this in an initializer at some point after the configuration directives.

```ruby
Deimos.boot! # Will execute a webrick HTTP handler in another thread
```

### Configuration

```ruby
Deimos.configure do |config|
    config.log_level = ENV.fetch("LOG_LEVEL", ::Logger::INFO)
    config.port      = ENV.fetch("PORT", 5000)
    config.bind      = ENV.fetch("BIND_IP", "0.0.0.0")
    # An application hash that allows you to add more rack apps
    # Doesn't override the defaults, just merges
    config.applications.merge('/path' => Rack::App.new)
    # Allows you to inject more middlewares into the application
    config.applications.middleware << Middleware
end
```

### Status

Deimos allows you to add as many status checks are you like, however the API expects a true or false response. Any false responses from the bound blocks will return an `internal_server_error`

```ruby
Deimos.status.add(:allocations) { AllocationService::Status.new.call }
Deimos.status.add(:another_check) { true }
```
```json
# GET /status
{ "allocations":true, "another_check":true }
```

Status checks are run in parallel.


### Metrics

Deimos uses `ActiveSupport::Notification` and `Prometheus` under the hood. 

#### Subscribing

The subsription takes, three required arguments and a block.
* The event name to subscribe to
* The type of collector
* The prometheus label

It also takes any extra keyword arguments and passes them to the collector, allowing you to specify extra options for each type of collector

* [Prometheus Collectors](https://github.com/prometheus/client_ruby#metrics)
* [ActiveSupport Notifications](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html)

```ruby
Deimos.metrics.subscribe('event.name', type: :gauge, label: 'Label') do |event, collector|
    collector.increment({}, event.payload[:value])
    # event is an ActiveSupport::Notification::Event
    # event.name      # => "render"
    # event.duration  # => 10 (in milliseconds)
    # event.payload   # => {some: :payload}

    # collector is a Prometheus::Client::#{type.classify}
  end
```

#### Instrumenting

`Deimos.metrics.instrument` delegates directly to `ActiveSupport::Notifications.instrument`, please see the [ActiveSupport Notifications](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html) documentation for more information

```ruby
Deimos.metrics.instrument('product_count', value: 10 + i) do
    # can wrap a block to give you code execution duration
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adamcarlile/deimos.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
