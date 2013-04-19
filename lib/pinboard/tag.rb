module Pinboard
  class Tag < Struct.new(:tag, :count)
    def initialize(attributes={})
      self.tag = attributes.delete(:tag)
      self.count  = attributes.delete(:count).to_i
    end
  end
end
