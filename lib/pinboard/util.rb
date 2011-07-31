module Pinboard
  module Util
    extend self

    def symbolize_keys(hash)
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end

    def parse_time(time)
      return time if time.is_a?(Time)
      return time.to_time if time.is_a?(Date)

      Time.parse(time)
    end
  end
end
