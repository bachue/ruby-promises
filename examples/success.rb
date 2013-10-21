$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'examples'
require 'promises'

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
  }

  promise.resolve 'http://www.google.com'
  
  promise.then {|_, _|
    EM.stop
    puts 'Success Here! Shutdown the EventMachine!'
  }

  puts '## END ##'
end
