require 'net/http'
require 'net/https'
require 'json'

module Elibom

  class Client

    def initialize(options={})
      @host = options[:host] || "http://www.elibom.com"
      @user = options[:user]
      @api_password = options[:api_password]

      raise ArgumentError, "Missing key ':user'" if @user.nil? || @user.empty?
      raise ArgumentError, "Missing key ':api_password'" if @api_password.nil? || @api_password.empty?
    end

    def send_message(args={})
      body = {}

      required_args = [:destinations, :text]
      required_args.each do |arg|
        raise ArgumentError, "Missing key ':#{arg}'" if args[arg].nil?
        body[arg] = args[arg]
      end

      post '/messages', body
    end

    def messages(delivery_id)
      get "/messages/#{delivery_id}"
    end
    alias :list_messages :messages

    def user(user_id)
      get "/users/#{user_id}"
    end

    def account
      get '/account'
    end

    private

      def get(resource)
        uri = URI.parse("#{@host}#{resource}")
        http = Net::HTTP.new(uri.host, uri.port)

        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth @user, @api_password
        request['Accept'] = 'application/json'

        response = http.request(request)

        case response
          when Net::HTTPSuccess
            JSON.parse(response.body)
          else
            response.error!
        end
      end

      def post(resource, body)
        uri = URI.parse("#{@host}#{resource}")
        http = Net::HTTP.new(uri.host, uri.port)

        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth @user, @api_password
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request.body = body.to_json

        response = http.request(request)

        case response
          when Net::HTTPSuccess
            JSON.parse(response.body)
          else
            response.error!
        end
      end

  end
end