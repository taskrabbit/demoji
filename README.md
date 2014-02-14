# Demoji

MySQL configured with utf-8 encoding blows up when trying to save text rows containing emojis, etc., to address this, Demoji rescues from that specific exception and replaces the culprit chars with empty spaces.

This is a workaround until Rails adds support for UTF8MB4 in migrations, schema, etc.

## Installation

Add this line to your application's Gemfile:

    gem 'demoji'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install demoji

## Usage

Write an initializer in: `config/initializers/demoji.rb`:

```ruby
ActiveRecord::Base.send :include, Demoji
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
