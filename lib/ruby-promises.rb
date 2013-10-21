module RubyPromises
  class CleanObject
    instance_methods.each { |m| undef_method m unless m.to_s =~ /^(?:nil\?|send|object_id)$|^__|^respond_to|^instance_/ }
  end
end

class Promise < RubyPromises::CleanObject
  class ThenEnv < RubyPromises::CleanObject
    def initialize success, error
      @success, @error, @started = success, error, false
    end

    def resolve *r
      @success.call(*r)
    end

    def reject *r
      @error.call(*r)
    end
  end

  def initialize
    @success_chain = []
    @error_chain = []
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
    @success_chain << [success, error]
    self
  end

  def resolve arg = nil
    _rescue 'can\'t call result twice!' if @started
    @started = true
    _apply arg
  end

  def method_missing method, *args
    result.send method, *args
  end

  private
    def _apply result = nil
      @result = result
      unless @success_chain.empty?
        current = @success_chain.shift
        @error_chain.unshift current
        ThenEnv.new(proc {|*r| _apply(*r) }, proc{|*r| _rescue(*r)}).
          instance_exec(result, &current[0])
      end
      @result
    end

    def _rescue err
      solved = false
      @error_chain.map {|_, error| error }.compact.each {|error|
        error.call err
        solved = true
      }
      raise err unless solved
    end
end
