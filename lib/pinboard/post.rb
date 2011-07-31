module Pinboard
  class Post < Struct.new(:href, :description, :tag, :time)
    def initialize(attributes={})
      self.time = Util.parse_time(attributes.delete(:time))

      attributes.each do |attribute, value|
        send("#{attribute}=", value) if respond_to?("#{attribute}=")
      end
    end
  end
end
