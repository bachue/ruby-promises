$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'examples'

EventMachine.run do
  promise = Promise.new
  promise.then(proc {|url|
    http = EventMachine::HttpRequest.new(url).get
    http.callback { 
      p http.response_header
      resolve 'http://www.ruby-china.org' 
    }
  }, proc {|err|
    EM.stop
    puts 'Succeed to stop EventMachine!'
  }).then {|url| 
    http = EventMachine::HttpRequest.new(url).get
    http.callback {
      p http.response_header
      resolve 'http://www.baidu.com'
    }
  }.then(proc {|url|
    http = EventMachine::HttpRequest.new(url).get
    http.callback {
      p http.response_header
      reject 'Success!'
    }
  }, proc {|err| puts "Get Error here: #{err}" }).then {
    EM.stop
    puts 'Fail!'
  }.resolve 'http://www.google.com'

  puts '## END ##'
end
