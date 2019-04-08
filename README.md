# RenaultZeAgent

[![Gem Version](https://badge.fury.io/rb/huginn_renault_ze_agent.svg)](https://badge.fury.io/rb/huginn_renault_ze_agent)
[![Build Status](https://travis-ci.org/nighthawk/huginn_renault_ze_agent.svg?branch=master)](https://travis-ci.org/nighthawk/huginn_renault_ze_agent)


The Renault ZE Battery Agent provides events on a scheduled basis for the Renault ZE Connect API,
providing battery status for a ZE vehicle.

You can use this for example to remind yourself to plug in your vehicle if it's below a certain
charge level, or to create a history of your vehicle's battery usage and remaining range.

## Installation

This gem is run as part of the [Huginn](https://github.com/huginn/huginn) project. If you haven't already, follow the [Getting Started](https://github.com/huginn/huginn#getting-started) instructions there.

Add this string to your Huginn's .env `ADDITIONAL_GEMS` configuration:

```ruby
huginn_renault_ze_agent
# when only using this agent gem it should look like this:
ADDITIONAL_GEMS=huginn_renault_ze_agent
```

And then execute:

    $ bundle

## Usage

It emits events such as:

```json
{
  "charge_level": 40, 
  "charging": false, 
  "last_update": 1554572276, 
  "plugged": false,
  "remaining_range": 115.0
}
```

## Development

Running `rake` will clone and set up Huginn in `spec/huginn` to run the specs of the Gem in Huginn as if they would be build-in Agents. The desired Huginn repository and branch can be modified in the `Rakefile`:

```ruby
HuginnAgent.load_tasks(branch: '<your branch>', remote: 'https://github.com/<github user>/huginn.git')
```

Make sure to delete the `spec/huginn` directory and re-run `rake` after changing the `remote` to update the Huginn source code.

After the setup is done `rake spec` will only run the tests, without cloning the Huginn source again.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/nighthawk/huginn_renault_ze_agent/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
