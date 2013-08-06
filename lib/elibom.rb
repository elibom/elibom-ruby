require File.expand_path('elibom/client', File.dirname(__FILE__))

# Ruby client of the Elibom API
module Elibom

  class << self
    def configure(options={})
      @client = Elibom::Client.new(options)
    end

    def method_missing(method_name, *args, &block)
      raise RuntimeError, "Please call Elibom.configure(:user => '...', :api_password => '...') first" if @client.nil?
      @client.send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, include_private=false)
      raise RuntimeError, "Please call Elibom.configure(:user => '...', :api_password => '...') first" if @client.nil?
      @client.respond_to?(method_name, include_private)
    end

    def reset!
      @client = nil
    end
  end
  
end