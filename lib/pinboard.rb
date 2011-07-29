require 'pinboard/client'

module Pinboard
  class << self
    def new(options={})
      Pinboard::Client.new(options)
    end
  end
end
