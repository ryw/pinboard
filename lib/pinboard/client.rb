require 'httparty'
require 'time'

module Pinboard
  # Raised when API returns failure
  Error = Class.new(StandardError)

  class Client
    include HTTParty
    base_uri 'api.pinboard.in:443/v1'

    # Construct a new instance of the client
    #
    # @param [Hash] options Options for the connection
    # @option options [String] :token The Pinboard API token (prefered over username & password)
    # @option options [String] :username Pinboard username
    # @option options [String] :password Pinboard password
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

    # Returns all bookmarks in the user's account.
    #
    # @return [Array<Post>] the list of bookmarks.
    def posts(params={})
      options = create_params(params)
      posts = self.class.get('/posts/all', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] if posts.class != Array
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    # Add a bookmark
    #
    # @param [Hash] params Arguments for this call
    # @option params [String] :url the URL of the item (required)
    # @option params [String] :description Title of the item
    # @option params [String] :extended Description of the item
    # @option params [Array] :tags List of up to 100 tags
    # @option params [Boolean] :replace Replace any existing bookmark with this URL (default: true)
    # @option params [Boolean] :shared Make bookmark public (default: true)
    # @option params [Boolean] :toread Marks the bookmark as unread (default: false)
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

    # Returns the most recent time a bookmark was added, updated or deleted.
    #
    # Use this before calling {#posts} to see if the data has changed
    # since the last fetch.
    #
    # @return [Time] the time a bookmark was modified
    def update
      options = create_params({})
      time = self.class.get('/posts/update', options)["update"]["time"]

      Time.parse time
    end

    # Returns a list of the user's most recent posts, filtered by tag.
    #
    # @param <Hash> params the options to filter current posts
    # @option params [String] :tag filter by up to three tags
    # @option params [String] :count Number of results to return.
    #                                Default is 15, max is 100
    #
    # @return [Array<Post>] the list of recent posts.
    def recent(params={})
      options = create_params(params)
      posts = self.class.get('/posts/recent', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [*posts]
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    # Returns a list of dates with the number of posts at each date.
    #
    # @param [String] tag Filter by up to three tags
    #
    # @return [Hash<String,Fixnum>] List of dates with number of posts
    #                               at each date
    def dates(tag=nil)
      params = {}
      params[:tag] = tag if tag

      options = create_params(params)
      dates = self.class.get('/posts/dates', options)['dates']['date']
      dates = [] if dates.nil?
      dates = [*dates]
      dates.each_with_object({}) { |value, hash|
        hash[value["date"]] = value["count"].to_i
      }
    end


    # Delete a bookmark
    #
    # @param [String] url The url to delete
    def delete(url)
      params = { url: url }
      options = create_params(params)
      result_code = self.class.get('/posts/delete', options).parsed_response["result"]["code"]

      raise Error.new(result_code) if result_code != "done"
    end

    # Returns a full list of the user's tags along with the number of
    # times they were used.
    #
    # @return [Array<Tag>] List of all tags
    def tags_get(params={})
      options = create_params(params)
      tags = self.class.get('/tags/get', options)['tags']['tag']
      tags = [] if tags.nil?
      tags = [*tags]
      tags.map { |p| Tag.new(Util.symbolize_keys(p)) }
    end

    # Rename an tag or fold it into an existing tag
    #
    # @param [String] old_tag Tag to rename (not case sensitive)
    # @param [String] new_tag New tag (if empty nothing will happen)
    #
    # @raise [Error] if result code is not "done"
    def tags_rename(old_tag, new_tag=nil, params={})
      params[:old] = old_tag
      params[:new] = new_tag if new_tag

      options = create_params(params)
      result_code = self.class.get('/tags/rename', options).parsed_response["result"]

      raise Error.new(result_code) if result_code != "done"
    end

    # Delete an existing tag
    #
    # @param [String] tag Tag to delete
    # @return [nil]
    def tags_delete(tag)
      params = { tag: tag }

      options = create_params(params)
      self.class.get('/tags/delete', options)
      nil
    end

    # Returns a list of the user's notes
    #
    # @return [Array<Note>] list of notes
    def notes_list
      options = create_params({})
      notes = self.class.get('/notes/list', options)['notes']['note']
      notes = [] if notes.nil?
      notes = [*notes]
      notes.map { |p| Note.new(Util.symbolize_keys(p)) }
    end

    private
    # Construct params hash for HTTP request
    #
    # @param [Hash] params Query arguments to include in request
    # @return [Hash] Options hash for request
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
