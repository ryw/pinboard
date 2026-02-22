require 'pinboard/util'
require 'pinboard/xml_parser'
require 'pinboard/client'
require 'pinboard/post'
require 'pinboard/tag'
require 'pinboard/note'

module Pinboard
  class << self
    def new(options={})
      Pinboard::Client.new(options)
    end

    def endpoint
      uri = Pinboard::Client::BASE_URI
      "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.path}"
    end
  end
end
