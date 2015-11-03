# Juan Pelota

Named after Lance Armstrong's coffee shop [Juan Pelota](http://www.juanpelotacafe.com/)
in Austin, TX.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'juan_pelota'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install juan_pelota
```

## Usage

Add this to your Sidekiq configuration:

```ruby
require 'juan_pelota'

Sidekiq.logger.formatter = JuanPelota::Logger.new
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/juan_pelota/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
