# RubyPromises

A lightweight gem implement AngularJS Promises in Ruby

AngularJS Promise introduction: <http://urish.org/angular/AngularPromises.pdf>

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-promises'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-promises

## Usage

```ruby
EventMachine.run do
  promise = Promise.new
  promise.then {|url|
    http = EventMachine::HttpRequest.new(url).get
    http.callback { 
      p http.response_header
      resolve 'http://www.ruby-china.org' 
    }
  }.then {|url| 
    http = EventMachine::HttpRequest.new(url).get
    http.callback {
      p http.response_header
      resolve 'http://www.vmware.com'
    }
  }.then {|url|
    http = EventMachine::HttpRequest.new(url).get
    http.callback {
      p http.response_header
      resolve 'http://www.emc.com'
    }
  }.then {
    http = EventMachine::HttpRequest.new(url).get
    http.callback {
      p http.response_header
      resolve
      puts 'Success Here! Shutdown the EventMachine!'
      EM.stop
    }
  }.resolve 'http://www.google.com'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
