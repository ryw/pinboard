require 'hash'
require 'pinboard/client'
require 'pinboard/post'

module Pinboard
  class << self
    def new(options={})
      Pinboard::Client.new(options)
    end
  end
end
