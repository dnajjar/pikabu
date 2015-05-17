# Pikabu
## Description

Pikabu is a gem that makes debugging a little bit easier by detecting errors in your ruby script and placing you in a binding environment right before the error occurs.  Alternatively, Pikabu can be called with a line number, placing you directly in a binding environment at that line, and all without modifying your original script. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pikabu'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pikabu

## Usage

You don't ever need to require pikabu in any of your scripts. To use it, run `pikabu [file_path.rb]` from the command line. Pikabu will place a binding.pry before the first error it detects and rerun your script. 

You can also run `pikabu [file_path.rb] [line #]`, and pikabu will insert a binding.pry at the line number specified. 

## Contributing
Comments and improvements are always welcome! 

1. Fork it ( https://github.com/dnajjar/pikabu/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
