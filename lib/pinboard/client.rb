require 'httparty'

module Pinboard
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
      posts = Array.new(1, posts) if !posts.nil? && !posts.kind_of?(Array)
      if !posts.nil?
        posts.map { |p| Post.new(Util.symbolize_keys(p)) }
      end
    end
  end
end
