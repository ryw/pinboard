require 'httparty'

module Pinboard
  class Client
    include HTTParty
    base_uri 'api.pinboard.in:443/v1'

    def initialize(options={})
      @auth = { :username => options[:username],
                :password => options[:password] }
    end

    def all_posts
      options = { :basic_auth => @auth }
      posts = self.class.get('/posts/all', options)['posts']['post']
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end
  end
end
