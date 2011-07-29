module Pinboard
  class Post
    attr_accessor :href, :description, :tag, :time

    def initialize(options={})
      @href = options[:href]
      @description = options[:description]
      @tag = options[:tag]
      @time = options[:time]
    end
  end
end
