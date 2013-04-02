require 'pinboard/util'
require 'pinboard/client'
require 'pinboard/post'
require 'pinboard/tag'

module Pinboard
  class << self
    def new(options={})
      Pinboard::Client.new(options)
    end

    def endpoint
      Pinboard::Client.base_uri
    end
  end
end
