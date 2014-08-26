require 'net/http'
require 'net/https'
require 'json'

module Elibom

  class Client

    def initialize(options={})
      @host = options[:host] || "https://www.elibom.com"
      @user = options[:user]
      @api_password = options[:api_password]

      raise ArgumentError, "Missing key ':user'" if @user.nil? || @user.empty?
      raise ArgumentError, "Missing key ':api_password'" if @api_password.nil? || @api_password.empty?
    end

    def send_message(args={})
      raise ArgumentError, "No args provided" if args.nil?
      raise ArgumentError, "Missing key ':to'" if args[:to].nil?
      raise ArgumentError, "Missing key ':text'" if args[:text].nil?
      raise ArgumentError, "Text is too long, max 160 characters" if args[:text].length > 160

      body = { "to" => args[:to], "text" => args[:text] }
      post '/messages', body
    end

    def schedule_message(args={})
      raise ArgumentError, "No args provided" if args.nil?
      raise ArgumentError, "Missing key ':to'" if args[:to].nil?
      raise ArgumentError, "Missing key ':text'" if args[:text].nil?
      raise ArgumentError, "Invalid argument ':text'. Too long, max 160 characters" if args[:text].length > 160
      raise ArgumentError, "Missing key ':schedule_date'" if args[:schedule_date].nil?
      raise ArgumentError, "Invalid argument ':schedule_date'" unless args[:schedule_date].respond_to?('strftime')

      body = { "to" => args[:to], "text" => args[:text], "scheduleDate" => args[:schedule_date].strftime('%Y-%m-%d %H:%M') }
      post '/messages', body
    end

    def show_delivery(delivery_id)
      raise ArgumentError, "'delivery_id' cannot be nil or empty" if delivery_id.nil? || delivery_id.empty?
      get "/messages/#{delivery_id}"
    end
    alias :delivery :show_delivery

    def scheduled_messages
      get "/schedules/scheduled"
    end
    alias :list_scheduled_messages :scheduled_messages

    def show_scheduled_message(schedule_id)
      raise ArgumentError, "'schedule_id' cannot be nil" if schedule_id.nil?
      get "/schedules/#{schedule_id}"
    end
    alias :scheduled_message :show_scheduled_message

    def cancel_schedule(schedule_id)
      raise ArgumentError, "'schedule_id' cannot be nil" if schedule_id.nil?
      delete "/schedules/#{schedule_id}"
    end
    alias :unschedule :cancel_schedule

    def users
      get "/users"
    end
    alias :list_users :users

    def show_user(user_id)
      raise ArgumentError, "'user_id' cannot be nil" if user_id.nil?
      get "/users/#{user_id}"
    end
    alias :user :show_user

    def show_account
      get '/account'
    end
    alias :account :show_account

    private

      def get(resource)
        uri = URI.parse("#{@host}#{resource}")
        http = get_http(uri)

        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth @user, @api_password
        request['Accept'] = 'application/json'
        request['X-API-Source'] = "ruby-#$elibom_version"

        response = http.request(request)
        parse_json_response(response)
      end

      def post(resource, body)
        uri = URI.parse("#{@host}#{resource}")
        http = get_http(uri)

        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth @user, @api_password
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request['X-API-Source'] = "ruby-#$elibom_version"
        request.body = body.to_json
        puts request['X-API-Source']

        response = http.request(request)
        parse_json_response(response)
      end

      def delete(resource)
        uri = URI.parse("#{@host}#{resource}")
        http = get_http(uri)

        request = Net::HTTP::Delete.new(uri.path)
        request['X-API-Source'] = "ruby-#$elibom_version"
        request.basic_auth @user, @api_password
        
        http.request(request)
      end

      def get_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
        end

        return http
      end

      def parse_json_response(response)
        case response
          when Net::HTTPSuccess
            JSON.parse(response.body)
          else
            response.error!
        end
      end

  end

end