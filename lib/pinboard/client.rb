require 'net/http'
require 'uri'
require 'time'
require 'pinboard/xml_parser'

module Pinboard
  # Raised when API returns failure
  Error = Class.new(StandardError)

  class Client
    BASE_URI = URI("https://api.pinboard.in:443/v1")

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
    # @option params [String] :tag filter by up to three tags
    # @option params [Integer] :start offset value (default is 0)
    # @option params [Integer] :results number of results to return. Default is all
    # @option params [Time] :fromdt return only bookmarks created after this time
    # @option params [Time] :todt return only bookmarks created before this time
    # @option params [Integer] :meta include a change detection signature for each bookmark
    # @return [Array<Post>] the list of bookmarks
    def posts(params = {})
      posts = http_get('/posts/all', params)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] unless posts.is_a?(Array)
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    # Returns one or more posts on a single day matching the arguments.
    # If no date or url is given, date of most recent bookmark will be used.
    #
    # @option params [String] :tag filter by up to three tags
    # @option params [Time] :dt return results bookmarked on this day
    # @option params [String] :url return bookmark for this URL
    # @option params [Boolean] :meta include a change detection signature in a meta attribute
    # @return [Array<Post>] the list of bookmarks
    def get(params = {})
      params[:dt] = params[:dt].to_date.to_s if params.is_a? Time
      params[:meta] = params[:meta] ? 'yes' : 'no' if params.has_key?(:meta)
      posts = http_get('/posts/get', params)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] unless posts.is_a?(Array)
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    # Returns a list of popular tags and recommended tags for a given URL.
    # Popular tags are tags used site-wide for the url; recommended tags
    # are drawn from the user's own tags.
    #
    # @param [String] url
    # @return [Hash<String, Array>]
    def suggest(url)
      suggested = http_get('/posts/suggest', {url: url})['suggested']

      if suggested.nil?
        popular = []
        recommended = []
      else
        popular = Array(suggested['popular'])
        recommended = Array(suggested['recommended'])
      end

      {:popular => popular, :recommended => recommended}
    end

    # Add a bookmark
    #
    # @param [Hash] params Arguments for this call
    # @option params [String] :url the URL of the item (required)
    # @option params [String] :description Title of the item (required)
    # @option params [String] :extended Description of the item
    # @option params [Array] :tags List of up to 100 tags
    # @option params [Time] :dt creation time for this bookmark. Defaults to current
    #   time. Datestamps more than 10 minutes ahead of server time will be reset to
    #   current server time
    # @option params [Boolean] :replace Replace any existing bookmark with this URL.
    #   Default is true. If set to false, will throw an error if bookmark exists
    # @option params [Boolean] :shared Make bookmark public. Default is true unless
    #   user has enabled the "save all bookmarks as private" user setting, in which
    #   case default is false
    # @option params [Boolean] :toread Marks the bookmark as unread (default: false)
    #
    # @return [String] "done" when everything went as expected
    # @raise [Error] if result code is not "done"
    def add(params={})
      # Pinboard expects multiple tags=foo,bar separated by comma instead of tag=foo&tag=bar
      params[:tags] = Array(params[:tags]).join(',') if params[:tags]

      # Pinboard expects datetime as UTC timestamp in this format:
      # 2010-12-11T19:48:02Z. Valid date range is Jan 1, 1 AD to January 1, 2100
      params[:dt] = params[:dt].iso8601 if params[:dt].is_a? Time

      # Pinboard expects replace, shared and toread as yes/no instead of true/false
      [:replace, :shared, :toread].each do |boolean|
        if params.has_key?(boolean) && !['yes', 'no'].include?(params[boolean])
          params[boolean] = params[boolean] ? 'yes' : 'no'
        end
      end

      result_code = http_post('/posts/add', params)["result"]["code"]

      raise Error.new(result_code) if result_code != "done"

      result_code
    end

    # Returns the most recent time a bookmark was added, updated or deleted.
    #
    # Use this before calling {#posts} to see if the data has changed
    # since the last fetch.
    #
    # @return [Time] the time a bookmark was modified
    def update
      time = http_get('/posts/update', {})["update"]["time"]

      Time.parse time
    end

    # Returns a list of the user's most recent posts, filtered by tag.
    #
    # @param <Hash> params the options to filter current posts
    # @option params [String] :tag filter by up to three tags
    # @option params [String] :count Number of results to return.
    #                                Default is 15, max is 100
    #
    # @return [Array<Post>] the list of recent posts
    def recent(params={})
      posts = http_get('/posts/recent', params)['posts']['post']
      posts = [] if posts.nil?
      posts = [*posts]
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    # Returns a list of dates with the number of posts at each date
    #
    # @param [String] tag Filter by up to three tags
    #
    # @return [Hash<String,Fixnum>] List of dates with number of posts
    #                               at each date
    def dates(tag=nil)
      params = {}
      params[:tag] = tag if tag

      dates = http_get('/posts/dates', params)['dates']['date']
      dates = [] if dates.nil?
      dates = [*dates]
      dates.each_with_object({}) { |value, hash|
        hash[value["date"]] = value["count"].to_i
      }
    end


    # Delete a bookmark
    #
    # @param [String] url The url to delete
    #
    # @return [String] "done" when everything went as expected
    # @raise [Error] if result code is not "done"
    def delete(url)
      params = { url: url }
      result_code = http_get('/posts/delete', params)["result"]["code"]

      raise Error.new(result_code) if result_code != "done"

      result_code
    end

    # Returns a full list of the user's tags along with the number of
    # times they were used.
    #
    # @return [Array<Tag>] List of all tags
    def tags_get(params={})
      tags = http_get('/tags/get', params)['tags']['tag']
      tags = [] if tags.nil?
      tags = [*tags]
      tags.map { |p| Tag.new(Util.symbolize_keys(p)) }
    end

    # Rename an tag or fold it into an existing tag
    #
    # @param [String] old_tag Tag to rename (not case sensitive)
    # @param [String] new_tag New tag (if empty nothing will happen)
    #
    # @return [String] "done" when everything went as expected
    # @raise [Error] if result code is not "done"
    def tags_rename(old_tag, new_tag=nil)
      params = {}
      params[:old] = old_tag
      params[:new] = new_tag if new_tag

      result_code = http_get('/tags/rename', params)["result"]

      raise Error.new(result_code) if result_code != "done"

      result_code
    end

    # Delete an existing tag
    #
    # @param [String] tag Tag to delete
    # @return [nil]
    def tags_delete(tag)
      params = { tag: tag }

      http_get('/tags/delete', params)
      nil
    end

    # Returns the user's secret RSS key (for viewing private feeds)
    #
    # @return [String]
    def user_secret()
      http_get('/user/secret', {})['result']
    end

    # Returns the user's API token (for making API calls without a password)
    #
    # @return [String]
    def user_api_token()
      http_get('/user/api_token', {})['result']
    end


    # Returns a list of the user's notes
    #
    # @return [Array<Note>] list of notes
    def notes_list
      notes = http_get('/notes/list', {})['notes']['note']
      notes = [] if notes.nil?
      notes = [*notes]
      notes.map { |p| Note.new(Util.symbolize_keys(p)) }
    end

    # Returns an individual user note. The hash property is a
    #   20 character long sha1 hash of the note text.
    #
    # @return [Note] the note
    def notes_get(id)
      note = http_get("/notes/#{id}", {})['note']

      return nil unless note

      # Complete hack, because the API is still broken
      content = '__content__'
      Note.new({
        id:      note['id'],
        # Remove whitespace around the title,
        # because of missing xml tag around
        title:   note[content].gsub(/\n|  +/, ''),
        length:  note['length'][content].to_i,
        text:    note['text'][content]
      })
    end

    private

    def http_get(path, params)
      uri = build_uri(path, params)
      request = Net::HTTP::Get.new(uri)
      apply_auth(request, uri)
      execute(uri, request)
    end

    def http_post(path, params)
      uri = build_uri(path, params)
      request = Net::HTTP::Post.new(uri)
      apply_auth(request, uri)
      execute(uri, request)
    end

    def build_uri(path, params)
      uri = URI(BASE_URI.to_s + path)
      query = params.transform_keys(&:to_s)
      query['auth_token'] = @auth_token if @auth_token
      uri.query = URI.encode_www_form(query) unless query.empty?
      uri
    end

    def apply_auth(request, uri)
      if @auth && !@auth_token
        request.basic_auth(@auth[:username], @auth[:password])
      end
    end

    def execute(uri, request)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      XMLParser.parse(response.body)
    end
  end
end
