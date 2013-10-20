class Promise
  instance_methods.each { |m| undef_method m unless m.to_s =~ /^(?:nil\?|send|object_id)$|^__|^respond_to|^instance_/ }

  def initialize
    @chain = []
  end

  def then success = nil, error = nil, &blk
    if blk
      if success.nil?
        success = blk
      elsif error.nil?
        error = blk
      end
    end
    raise ArgumentError.new('the first arg should be callable') unless success.respond_to?(:call)
    raise ArgumentError.new('the second arg should be callable') unless !error || error.respond_to?(:call)
    @chain << [success, error]
    self
  end

  def result arg = nil
    _apply arg
  end

  def method_missing method, *args
    result.send method, *args
  end

  private
    def _apply result = nil, i = 0, chain = @chain
      @result = result
      unless chain.empty?
        begin
          chain[0][0].call result, proc {|r| _apply r, i + 1, chain[1..-1] }
        rescue => err
          _rescue i, err
        end
      end
      @result
    end

    def _rescue idx, err
      solved = false
      @chain[0..idx].reverse.map {|_, error| error }.compact.each {|error|
        @result = error.call err
        solved = true
        break if @result
      }
      raise err unless solved
    end
end

puts 'example 1'

promise = Promise.new
p promise.
  then {|v, app| puts "v: #{v}"; sleep 1; app.call v + 2 }.
  then {|v, app| puts "v: #{v}"; sleep 2; app.call v + 3 }.
  then {|v, app| puts "v: #{v}"; sleep 3; app.call v + 4 }.
  then {|v, app| puts "v: #{v}"; sleep 4; app.call v + 5 }.
  then {|v, app| puts "v: #{v}"; sleep 5; app.call v + 6 }.
  then {|v, app| puts "v: #{v}"; sleep 6; app.call v + 7 }.
  result 1

puts 'example 2'

promise = Promise.new
p promise.
  then {|_, app| sleep 1; app.call 1 }.
  then(lambda {|result, app| puts result; sleep 2; app.call 2 }, lambda {|err| puts '2: ' + err.message; 4 }).
  then(lambda {|result, app| puts result; sleep 3; raise 'error' }, lambda {|err| puts '3: ' + err.message }).
  to_s
