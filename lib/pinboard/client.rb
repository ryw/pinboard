require 'httparty'
require 'time'

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

    def update
      options = create_params({})
      time = self.class.get('/posts/update', options)["update"]["time"]

      Time.parse time
    end

    def recent(params={})
      options = create_params(params)
      posts = self.class.get('/posts/recent', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [*posts]
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    def dates(params={})
      options = create_params(params)
      dates = self.class.get('/posts/dates', options)['dates']['date']
      dates = [] if dates.nil?
      dates = [*dates]
      dates.each_with_object({}) { |value, hash|
        hash[value["date"]] = value["count"].to_i
      }
    end

    def delete(params={})
      options = create_params(params)
      result_code = self.class.get('/posts/delete', options).parsed_response["result"]["code"]

      raise Error.new(result_code) if result_code != "done"
    end

    def tags_get(params={})
      options = create_params(params)
      tags = self.class.get('/tags/get', options)['tags']['tag']
      tags = [] if tags.nil?
      tags = [*tags]
      tags.map { |p| Tag.new(Util.symbolize_keys(p)) }
    end

    def tags_rename(old_tag, new_tag=nil, params={})
      params[:old] = old_tag
      params[:new] = new_tag if new_tag

      options = create_params(params)
      result_code = self.class.get('/tags/rename', options).parsed_response["result"]

      raise Error.new(result_code) if result_code != "done"
    end

    def tags_delete(tag, params={})
      params[:tag] = tag

      options = create_params(params)
      self.class.get('/tags/delete', options)
      nil
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
