require 'httparty'

module Pinboard
  Error = Class.new(StandardError)

  class Client
    include HTTParty
    base_uri 'api.pinboard.in:443/v1'

    def initialize(options={})
      @auth = { :username => options[:username],
                :password => options[:password] }
    end

    def posts(params={})
      options = {}
      options[:basic_auth] = @auth
      options[:query] = params
      posts = self.class.get('/posts/all', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] if posts.class != Array
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    def add(params={})
      options = {}
      options[:basic_auth] = @auth
      options[:query] = params
      result_code = self.class.post('/posts/add', options).parsed_response["result"]["code"]

      raise Error.new(result_code) if result_code != "done"
    end

    def delete(params={})
      options = {}
      options[:basic_auth] = @auth
      options[:query] = params
      result_code = self.class.get('/posts/delete', options).parsed_response["result"]["code"]

      raise Error.new(result_code) if result_code != "done"
    end
  end
end
