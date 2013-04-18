require 'httparty'

module Pinboard
  Error = Class.new(StandardError)

  class Client
    include HTTParty
    base_uri 'api.pinboard.in:443/v1'

    def initialize(options={})
      @auth       = nil
      @auth_token = nil

      if (token=options.delete(:token))
        @auth_token = token
      else
        @auth = {
          username: options[:username],
          password: options[:password]
        }
      end
    end

    def posts(params={})
      options = create_params(params)
      posts = self.class.get('/posts/all', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] if posts.class != Array
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    def add(params={})
      # Pinboard expects multiple tags=foo,bar separated by comma instead of tag=foo&tag=bar
      params[:tags] = Array(params[:tags]).join(',') if params[:tags]

      # Pinboard expects replace, shared and toread as yes/no instead of true/false
      [:replace, :shared, :toread].each do |boolean|
          params[boolean] = params[boolean] ? 'yes' : 'no' if params.has_key?(boolean)
      end

      options = create_params(params)
      result_code = self.class.post('/posts/add', options).parsed_response["result"]["code"]

      raise Error.new(result_code) if result_code != "done"
    end

    def delete(params={})
      options = create_params(params)
      result_code = self.class.get('/posts/delete', options).parsed_response["result"]["code"]

      raise Error.new(result_code) if result_code != "done"
    end

    private
    def create_params params
      options = {}
      options[:query] = params

      if @auth_token
        options[:query].merge!(auth_token: @auth_token)
      else
        options[:basic_auth] = @auth
      end

      options
    end
  end
end
