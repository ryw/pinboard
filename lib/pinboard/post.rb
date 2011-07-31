module Pinboard
  class Post < Struct.new(:href, :description, :tag, :time)
    def initialize(attributes={})
      attributes.each do |attribute, value|
        send("#{attribute}=", value) if respond_to?("#{attribute}=")
      end
    end
  end
end
