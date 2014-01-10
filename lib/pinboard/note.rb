module Pinboard
  class Note < Struct.new(:id, :title, :created_at, :updated_at, :length, :text)
    def initialize(attributes={})
      self.id         = attributes[:id]
      self.title      = attributes[:title]
      self.created_at = attributes[:created_at] && Util.parse_time(attributes[:created_at])
      self.updated_at = attributes[:updated_at] && Util.parse_time(attributes[:updated_at])
      self.length     = attributes[:length].to_i
      self.text       = attributes[:text]
    end

    def to_json(*args)
      {
        id:          id,
        title:       title,
        created_at:  created_at,
        updated_at:  updated_at,
        length:      length
      }.to_json(*args)
    end
  end
end
