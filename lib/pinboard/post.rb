module Pinboard
  class Post < Struct.new(:href, :description, :tag, :time)
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
  end
end
