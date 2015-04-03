module Pinboard
  class Post < Struct.new(:href, :description, :extended, :tag, :time, :replace, :shared, :toread)
    def self.all(options={})
      client = Pinboard::Client.new(options)
      posts = client.class.get('/posts/all',
                :basic_auth => options)['posts']['post']
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    def initialize(attributes={})
      self.time = Util.parse_time(attributes.delete(:time))
      self.tag  = attributes.delete(:tag).split(" ")

      attributes.each do |attribute, value|
        send("#{attribute}=", value) if respond_to?("#{attribute}=")
      end
    end

    def to_json(*args)
      {
        href:         href,
        description:  description,
        extended:     extended,
        tag:          tag,
        time:         time,
        replace:      replace,
        shared:       shared,
        toread:       toread
      }.to_json(*args)
    end

    # Creates hash for API (e.g. pass it to '/posts/add')
    #
    # @param [Boolean, nil] replace Overwrite replace attribute if not nil
    # @return [Hash]
    def api_hash(replace = nil)
      self.replace = replace unless replace.nil?
      {
        url:          href,
        description:  description,
        extended:     extended,
        tags:         tag.join(" "),
        replace:      replace,
        shared:       shared,
        toread:       toread
      }.select { |key, value| ! value.nil? }
    end
  end
end
